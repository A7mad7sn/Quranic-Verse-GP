import pandas as pd
from qalsadi.lemmatizer import Lemmatizer

quran_surahs_arabic = [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة",
    "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس",
    "هود", "يوسف", "الرعد", "إبراهيم", "الحجر",
    "النحل", "الإسراء", "الكهف", "مريم", "طه",
    "الأنبياء", "الحج", "المؤمنون", "النور", "الفرقان",
    "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
    "لقمان", "السجدة", "الأحزاب", "سبإ", "فاطر",
    "يس", "الصافات", "ص", "الزمر", "غافر",
    "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية",
    "الأحقاف", "محمد", "الفتح", "الحجرات", "ق",
    "الذاريات", "الطور", "النجم", "القمر", "الرحمن",
    "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة",
    "الصف", "الجمعة", "المنافقون", "التغابن", "الطلاق",
    "التحريم", "الملك", "القلم", "الحاقة", "المعارج",
    "نوح", "الجن", "المزمل", "المدثر", "القيامة",
    "الإنسان", "المرسلات", "النبأ", "النازعات", "عبس",
    "التكوير", "الإنفطار", "المطففين", "الإنشقاق", "البروج",
    "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
    "الشمس", "الليل", "الضحى", "الشرح", "التين",
    "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
    "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل",
    "قريش", "الماعون", "الكوثر", "الكافرون", "النصر",
    "المسد", "الإخلاص", "الفلق", "الناس"
]

def basic_search(sentence, verses):
    found_verses = []
    found_indices = []

    for index, verse in enumerate(verses):
        if sentence in verse:
            found_verses.append(verse)
            found_indices.append(index)

    if not found_verses:
        print("Sentence not found in any verse.")
    else:
        return found_verses, found_indices
def search_word_in_verse(word, verse):
    # Split the verse into individual words
    words = verse.split()

    for w in words:
        # Split the word into individual letters
        letters = list(w)
        index = 0
        # Iterate through each letter in the word
        for letter in letters:
            # Check if the current letter matches the letter in the target word
            if letter == word[index]:
                # Move to the next letter in the target word
                index += 1
                # If all letters of the target word are found, return True
                if index == len(word):
                    return True
    return False


def find_verse_with_word_subset(sentence, verses, original_verses):
    # Split the sentence into individual words
    words = sentence.split()
    found_verses = []
    found_indices = []
    # Iterate through each verse and its corresponding index
    for i, verse in enumerate(verses):
        if all(search_word_in_verse(word, verse) for word in words):
            # If all words are found, add the verse to the list of found verses
            found_verses.append(original_verses[i])
            found_indices.append(i)
    return found_verses, found_indices


def read_csv1(path):
    dataset = pd.read_excel(path)
    preproc_verses = dataset.iloc[:, 0]
    lemmatized_verses = dataset.iloc[:, 1]
    return preproc_verses, lemmatized_verses


def read_csv2(path):
    verse_info = pd.read_excel(path)
    column = verse_info.iloc[:, 0]
    tafseer = verse_info.iloc[:, 4]

    verses = verse_info.iloc[:, 3]  # Verses with Tashkeel
    return verse_info, verses, column, tafseer


def read_csv3(path):
    lemma_tafsir = pd.read_excel(path)
    lemmatized_tafsir = lemma_tafsir.iloc[:, 1]
    return lemmatized_tafsir


def perform_search(word, choice):
    preproc_verses, lemmatized_verses = read_csv1("lemmatized_quran.xlsx")
    verse_info, verses, column, tafseer = read_csv2("Tafseer.xlsx")
    lemmatized_tafsir = read_csv3("lemmatized_tafsser.xlsx")

    if choice == 1:
        result, indices = basic_search(word, preproc_verses)
    elif choice == 2:
        result, indices = find_verse_with_word_subset(word, preproc_verses, verses)
    elif choice == 3:
        lemmatizer = Lemmatizer()
        lemma = lemmatizer.lemmatize(word)
        result_1, indices_1 = find_verse_with_word_subset(lemma, lemmatized_tafsir, verses)
        result_2, indices_2 = find_verse_with_word_subset(lemma, lemmatized_verses, verses)
        combined_result = result_1 + result_2
        combined_indices = indices_1 + indices_2
        result = list(set(combined_result))
        indices = list(set(combined_indices))

    else:
        raise ValueError("Invalid choice")

    return result, indices, verse_info, column


def display_results(result, indices, verse_info, column, choice):
    if result:
        print("The word subset exists in the following sentences:")
        count = 0
        for idx in indices:
            index = column[idx]  # Get the index from the column
            surah_index = verse_info.iloc[index, 1]
            surah_name = quran_surahs_arabic[surah_index - 1]  # Adjust indexing to start from 1
            print("Surah Name:", surah_name)
            print("Verse Number:", verse_info.iloc[index, 2])
            print("Verse:", verse_info.iloc[index, 3])  # Display the verse from the corresponding row
            if choice == 3:
                print("Tafseer:", verse_info.iloc[index, 4])
            print()
            count += 1
        print("Number of verses:", count)
    else:
        print("The word subset does not exist in any sentence.")


if __name__ == "__main__":
    word = input("Enter the word to search for in the verses: ")
    choice = int(input(
        "Please enter your choice:\n[1] Search in original Quran verses\n"
        "[2] Search in lemmatized Quran verses\n"
        "[3] Deep Search in Tafseer\n"))
    result, indices, verse_info, column = perform_search(word, choice)
    display_results(result, indices, verse_info, column, choice)
