import datetime
import json
import os

import requests
import streamlit as st
import torch
import torchvision.transforms as transforms
from azure.storage.blob import BlobServiceClient
from PIL import Image
from torchvision import models

st.set_page_config(page_title="Rozpoznawanie Zwierząt", layout="centered")

st.title("Rozpoznawanie Zwierząt")
st.write("Prześlij zdjęcie zwierzęcia, a nasz model rozpozna jego gatunek.")


@st.cache_resource
def load_model():
    model = models.resnet50(pretrained=True)
    model.eval()
    return model


model = load_model()


@st.cache_data
def load_imagenet_labels():
    LABELS_URL = (
        "https://raw.githubusercontent.com/anishathalye/"
        "imagenet-simple-labels/master/imagenet-simple-labels.json"
    )
    response = requests.get(LABELS_URL)
    labels = json.loads(response.text)
    return labels


imagenet_labels = load_imagenet_labels()

transform = transforms.Compose(
    [
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ]
)

uploaded_file = st.file_uploader(
    "Wybierz zdjęcie zwierzęcia", type=["jpg", "jpeg", "png"]
)

if uploaded_file:
    image = Image.open(uploaded_file).convert("RGB")
    st.image(image, caption="Przesłane zdjęcie", use_column_width=True)

    if st.button("Rozpoznaj zwierzę"):
        input_tensor = transform(image).unsqueeze(0)

        with torch.no_grad():
            outputs = model(input_tensor)
            _, predicted_idx = outputs.max(1)
            predicted_label = imagenet_labels[predicted_idx.item()]

        st.success(f"Rozpoznano: **{predicted_label.capitalize()}**")

        timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        storage_path_prefix = f"{timestamp}/"

        connection_string = os.environ.get("AZURE_STORAGE_CONNECTION_STRING")

        if connection_string is None:
            st.error(
                "Nie znaleziono zmiennej środowiskowej AZURE_STORAGE_CONNECTION_STRING"
            )
        else:
            try:
                # Inicjalizacja klienta Azure Blob
                blob_service_client = BlobServiceClient.from_connection_string(
                    connection_string
                )
                container_client = blob_service_client.get_container_client(
                    "predictions"
                )

                # input.png
                image_bytes = uploaded_file.read()
                container_client.upload_blob(
                    f"{storage_path_prefix}input.png", image_bytes, overwrite=True
                )

                # input.txt
                input_info = (
                    f"Uploaded file name: {uploaded_file.name}\nModel input tensor shape:"
                    f" {input_tensor.shape}\n"
                )
                container_client.upload_blob(
                    f"{storage_path_prefix}input.txt", input_info, overwrite=True
                )

                # output.txt
                container_client.upload_blob(
                    f"{storage_path_prefix}output.txt", predicted_label, overwrite=True
                )

                st.write(f"Dane zapisane w Azure Blob Storage: `{storage_path_prefix}`")

            except Exception as e:
                st.error(f"Błąd podczas zapisu do Azure Blob Storage: {e}")
