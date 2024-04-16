import string
import re
import nltk
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import pickle
from keras.preprocessing.sequence import pad_sequences
import qalsadi.lemmatizer
import numpy as np


def preprocess(text):
    # Stop Words removal
    stop_words = set(stopwords.words('arabic'))
    arabic_Tashkeel = re.compile("""
                                ّ    | # Shadda
                                َ    | # Fatha
                                ً    | # Tanwin Fath
                                ُ    | # Damma
                                ٌ    | # Tanwin Damm
                                ِ    | # Kasra
                                ٍ    | # Tanwin Kasr
                                ْ    | # Sukun
                                ـ    | # Tatwil/Kashida
                                ٓ    | # Maddah Above
                                ٔ    | # Hamza Above
                                ٕ    | # Hamza Below
                                ٖ    | # Subscript Alef
                                ٗ    | # Inverted Damma
                                ٘    | # Mark Noon Ghunna
                                ٙ    | # Inverted Damma Below
                                ٚ    | # Mark Sideways Noon Ghunna
                                ٛ    | # Kasra with Wavy Hamza Below
                                ٜ    | # Fatha with Wavy Hamza Above
                                ٝ    | # Fatha with Wavy Hamza Below
                                ٞ    | # Fatha with Ring
                                ٟ    | # Fatha with Dot Above
                            """, re.VERBOSE)

    words = word_tokenize(text)

    filtered_words = [word for word in words if
                      word.lower() not in stop_words and not any(char.isdigit() for char in word)]

    filtered_text = ' '.join(filtered_words)

    arabic_punctuation = string.punctuation + '؛،؟«»'

    translator = str.maketrans('', '', arabic_punctuation)
    filtered_text = filtered_text.translate(translator)

    filtered_text = re.sub(arabic_Tashkeel, '', filtered_text)

    text = filtered_text

    # Lemmatizing
    lemmer = qalsadi.lemmatizer.Lemmatizer()
    lemmas = lemmer.lemmatize_text(text)
    text = " ".join(lemmas)

    # Feature Extraction

    with open('C:\\Users\\boody\Downloads\gp\\tokenizer.pickle', 'rb') as handle:
        tokenizer = pickle.load(handle)

    text = [text]
    sequences = tokenizer.texts_to_sequences(text)
    padded_sequences = pad_sequences(sequences, maxlen=5)
    return padded_sequences


def rank_N_verse(output_list, N):
    flat_array = np.concatenate(output_list)

    top_100_indices = np.argsort(flat_array)[-N:][::-1]

    # Loading the encoder
    with open('C:\\Users\\boody\Downloads\gp\\onehot_encoder.pkl', 'rb') as handle:
        encoder = pickle.load(handle)

    top_N_verse = []
    for index in top_100_indices:
        encoded = np.zeros(6062)
        encoded[index] = 1
        verse = encoder.inverse_transform(encoded.reshape(1, -1))
        top_N_verse.append(str(verse[0][0]))

    return top_N_verse
