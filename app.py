import streamlit as st
from PIL import Image

st.set_page_config(page_title="Rozpoznawanie Zwierząt", layout="centered")

st.title("🐾 Rozpoznawanie Zwierząt")
st.write("Prześlij zdjęcie zwierzęcia, a nasz model (wkrótce!) rozpozna jego gatunek.")

uploaded_file = st.file_uploader("Wybierz zdjęcie zwierzęcia", type=["jpg", "jpeg", "png"])

if uploaded_file:
    image = Image.open(uploaded_file)
    st.image(image, caption="Przesłane zdjęcie", use_column_width=True)

    if st.button("Rozpoznaj zwierzę"):
        st.success("📢 Model wkrótce dostępny! (to tylko placeholder)")
