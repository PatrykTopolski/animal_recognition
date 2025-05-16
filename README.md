# Rozpoznawanie Zwierząt – Wersja Demo

Aplikacja umożliwia przesyłanie zdjęcia zwierzęcia i w przyszłości rozpoznanie jego gatunku przez model AI. Obecnie aplikacja wyświetla placeholder zamiast rzeczywistego wyniku analizy.

## Opis działania

1. Użytkownik przesyła obrazek zwierzęcia w formacie JPG, JPEG lub PNG.
2. Aplikacja wyświetla przesłane zdjęcie na ekranie.
3. Kliknięcie przycisku „Rozpoznaj zwierzę” powoduje wyświetlenie komunikatu informującego o przyszłej dostępności modelu AI.

## Wymagania

Aby uruchomić aplikację, musisz mieć zainstalowane:

- **Python** (wersja 3.7 lub nowsza)
- **Pip** (menedżer pakietów Pythona)
- **Streamlit** (do obsługi interfejsu)
- **Pillow** (do przetwarzania obrazów)

## Instalacja zależności

Jeśli wymagane pakiety nie są zainstalowane, uruchom poniższe polecenie, które sprawdzi czy wymagane pakiety istnieją i uruchomi aplikacje:

 - ***unix/wsl*** ./run.sh
 - ***windows*** ./run/ps1

Jeżeli wymagane pakiety istnieją aplikacje uruchamia się komentą:

 - streamlit run app.py


### Budowanie obrazu
```bash
docker build -t animal_recognition .
```

### Uruchamianie Obrazu
```bash
docker run -p 8501:8501 animal_recognition
```
