import pandas as pd
import json
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from arabic_reshaper import arabic_reshaper
from voice_to_text import *

def load_quran_surahs(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            quran_surahs = json.load(file)
        return quran_surahs
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        return None
    except json.JSONDecodeError:
        print(f"Error: Unable to decode JSON in file '{file_path}'.")
        return None

def map_surah_name_to_index(surah_name, quran_surahs):
    for index, surah_data in quran_surahs.items():
        if surah_name == 'النبإ' or surah_name == 'سبإ':
            current_surrah = surah_data['name']
        else:
            current_surrah = surah_data['name'].replace('أ', 'ا')
            current_surrah = current_surrah.replace('إ', 'ا')
        if 'name' in surah_data and current_surrah == surah_name:
            return int(index)

    return f"No index found for surah '{surah_name}'."


def get_specific_ayah(df, sora_index, ayah):
    ayah = int(ayah)
    for i in range(len(df)):
        if df['sora'][i] == sora_index:
            if df['aya'][i] == ayah:
                return df['text'][i]

def search_in_excel(df, search_query):
    # Read the CSV file into a DataFrame

    # Assuming your CSV file has a column named 'text' containing the text data
    text_column = 'tafseer'


    # Perform the search
    result_df = df[df[text_column].str.contains(search_query, case=False)]

    return result_df['text']

if __name__ == "__main__":

    # Native Search
    search_query = 'رحم'
    df = pd.read_excel('Tafseer.xlsx')

    result = search_in_excel(df, search_query)

    # Display the result
    print(result)
    print('--------------------------------------')

    # Example usage:
    file_path = 'surah.json'  # Replace with the actual path to your JSON file
    quran_surahs_data = load_quran_surahs(file_path)

    ayah_number, surah = speech_recognizer()

    if quran_surahs_data:
        surah_name = surah
        surah_index = map_surah_name_to_index(surah_name, quran_surahs_data)
        print(f"The index of surah '{surah_name}' is: {surah_index}")
        ayah = get_specific_ayah(df,surah_index,ayah_number)
        print(ayah)
