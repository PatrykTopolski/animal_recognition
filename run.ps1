# Sprawdzenie wersji Pythona
if (-Not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python nie jest zainstalowany. Zainstaluj go i spróbuj ponownie." -ForegroundColor Red
    exit 1
}

# Instalacja zależności
Write-Host "Instalowanie zależności..." -ForegroundColor Yellow
pip install streamlit pillow
pip install -r requirements.txt

# Uruchomienie aplikacji
Write-Host "Uruchamianie aplikacji Streamlit..." -ForegroundColor Green
python -m streamlit run app.py
