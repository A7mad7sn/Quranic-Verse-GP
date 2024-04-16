import re


def swap_ha_with_ta_except_taha(word):
    # Swap 'ه' with 'ة' except for the word 'طه'
    if word != 'طه':
        word = word.replace('ه', 'ة')
    return word


def speech_recognizer(t):
    # Extract number using regular expression
    number_words = {
        'واحد': '1',
        'ثلاثه': '3',
        'ثمانيه': '8',
    }
    for word, number in number_words.items():
        t = t.replace(word, number)
    number_match = re.search(r'\b\d+\b', t)
    number = number_match.group() if number_match else None
    print("You said:", t)

    # Extract the word after "سورة" with variations
    surah_match = re.search(r'\bسور[ةه]\b\s+([^\s]+)', t, re.IGNORECASE)

    surah_word = surah_match.group(1) if surah_match else None

    if surah_word == 'ال':
        surah_match = re.search(r'\bسور[ةه]\b\s+([^\s]+)\s+([^\s]+)', t, re.IGNORECASE)
        surah_word = surah_match.group(1) + ' ' + surah_match.group(2) if surah_match else None

    if surah_word == "ال عمران":
        surah_word = surah_word.replace('ال عمران', 'آل عمران')

    # Swap 'ه' with 'ة' except for the word 'طه'
    surah_word = swap_ha_with_ta_except_taha(surah_word)

    print("Extracted Number:", number)
    print("Extracted Word  :", surah_word)



    return number, surah_word
