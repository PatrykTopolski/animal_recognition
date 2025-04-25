import streamlit as st
from PIL import Image
import torch
import torchvision.transforms as transforms
from torchvision import models
import json
import requests

st.set_page_config(page_title="Rozpoznawanie Zwierząt", layout="centered")

st.title("🐾 Rozpoznawanie Zwierząt")
st.write("Prześlij zdjęcie zwierzęcia, a nasz model rozpozna jego gatunek.")

@st.cache_resource
def load_model():
    model = models.resnet50(pretrained=True)
    model.eval()
    return model

model = load_model()

@st.cache_data
def load_imagenet_labels():
    LABELS_URL = "https://raw.githubusercontent.com/anishathalye/imagenet-simple-labels/master/imagenet-simple-labels.json"
    response = requests.get(LABELS_URL)
    labels = json.loads(response.text)
    return labels

imagenet_labels = load_imagenet_labels()

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406], 
        std=[0.229, 0.224, 0.225]
    )
])

uploaded_file = st.file_uploader("Wybierz zdjęcie zwierzęcia", type=["jpg", "jpeg", "png"])

if uploaded_file:
    image = Image.open(uploaded_file).convert('RGB')
    st.image(image, caption="Przesłane zdjęcie", use_column_width=True)

    if st.button("Rozpoznaj zwierzę"):
        input_tensor = transform(image).unsqueeze(0) 

        with torch.no_grad():
            outputs = model(input_tensor)
            _, predicted_idx = outputs.max(1)
            predicted_label = imagenet_labels[predicted_idx.item()]

        st.success(f"📢 Rozpoznano: **{predicted_label.capitalize()}**")
