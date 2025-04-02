#!/bin/bash

# Sprawdzenie, czy Python i pip są zainstalowane
if ! command -v python3 &> /dev/null; then
    echo "Python3 nie jest zainstalowany. Zainstaluj go i spróbuj ponownie."
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 nie jest zainstalowany. Zainstaluj go i spróbuj ponownie."
    exit 1
fi

# Sprawdzenie i instalacja zależności
echo "Sprawdzanie zależności..."
pip3 install --upgrade pip
pip3 install --quiet streamlit pillow

# Uruchomienie aplikacji
echo "Uruchamianie aplikacji Streamlit..."
streamlit run app.py
