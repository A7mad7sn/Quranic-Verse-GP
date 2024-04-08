import re
import speech_recognition as sr

def swap_ha_with_ta_except_taha(word):
    # Swap 'ه' with 'ة' except for the word 'طه'
    if word != 'طه':
        word = word.replace('ه', 'ة')
    return word

def speech_recognizer():
    r = sr.Recognizer()

    with sr.Microphone() as source2:
        r.adjust_for_ambient_noise(source2, duration=0.2)
        print('Say something')
        audio = r.listen(source2)

    try:
        t = r.recognize_google(audio, language='ar-AR')
        print("You said:", t)

        # Extract number using regular expression
        number_match = re.search(r'\b\d+\b', t)
        number = number_match.group() if number_match else None

        # Extract the word after "سورة" with variations
        surah_match = re.search(r'\bسور[ةه]\b\s+([^\s]+)', t, re.IGNORECASE)

        surah_word = surah_match.group(1) if surah_match else None

        if surah_word == 'ال':
            surah_match = re.search(r'\bسور[ةه]\b\s+([^\s]+)\s+([^\s]+)', t, re.IGNORECASE)
            surah_word = surah_match.group(1) + ' ' + surah_match.group(2) if surah_match else None



        surah_word = surah_word.replace('ال عمران', 'آل عمران')


        # Swap 'ه' with 'ة' except for the word 'طه'
        surah_word = swap_ha_with_ta_except_taha(surah_word)




        print("Extracted Number:", number)
        print("Extracted Word  :", surah_word)

        # Save the extracted information to a text file
        if number and surah_word:
            with open('text.txt', 'a', encoding='utf-8') as f:
                f.write(f'Number: {number}, Word after "سورة": {surah_word}\n')

    except sr.UnknownValueError as U:
        print(U)
    except sr.RequestError as R:
        print(R)

    return number, surah_word


