import pandas as pd

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


def search_word_in_verse(word, verse):
    # Split the verse into individual words
    words = verse.split()
    # Iterate through each word in the verse
    for w in words:
        # Check if the target word is a subset of any word in the verse
        if word in w:
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


word = input("Enter the word to search for in the verses: ")

dataset = pd.read_excel("lemmatized_quran.xlsx")
preproc_verses= dataset.iloc[:,0]                      #Verses without Tashkeel

verse_info=pd.read_excel("Tafseer.xlsx")
column=verse_info.iloc[:,0]


verses = verse_info.iloc[:, 3]                          #Verses with Tashkeel
lemmatized_verses = dataset.iloc[:, 1]                  #Lemmatized Verses

choice = int(input("Please enter your choice:\n[1] Search in original Quran verses\n[2] Search in lemmatized Quran verses\n"))
if choice == 1:
    result, indices = find_verse_with_word_subset(word, preproc_verses, verses)
elif choice == 2:
    result, indices = find_verse_with_word_subset(word, lemmatized_verses, verses)
else:
    print("Wrong choice")


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
        print()
        count += 1
    print("Number of verses:", count)
else:
    print("The word subset does not exist in any sentence.")

