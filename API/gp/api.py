from flask import Flask, request, jsonify, render_template
from qalsadi.lemmatizer import Lemmatizer
import pandas as pd
from subset import (perform_search, quran_surahs_arabic)
from speechrecognition import (swap_ha_with_ta_except_taha, speech_recognizer)
from text_voice import (load_quran_surahs, map_surah_name_to_index, get_specific_ayah)
from model import (preprocess, rank_N_verse)
from keras.models import load_model

app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
    return "it is working"


@app.route('/search', methods=['POST'])
def search_verses():
    # word = request.args.get('word')
    # choice = request.args.get('choice', default=1, type=int)
    data = request.get_json()  # Assuming the request has a JSON body
    word = data['word']
    choice = data.get('choice', 1)

    if not word or choice not in [1, 2, 3]:
        return jsonify({"error": "Missing or invalid parameters"}), 400

    try:
        result, indices, verse_info, column = perform_search(word, choice)
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    if not result:
        return jsonify({"message": "The word subset does not exist in any sentence."}), 404

    response_data = []
    for idx in indices:
        index = int(column[idx])  # Convert to int
        surah_index = int(verse_info.iloc[index, 1])  # Convert to int
        surah_name = quran_surahs_arabic[surah_index - 1]
        verse_number = int(verse_info.iloc[index, 2])  # Convert to int
        verse_text = str(verse_info.iloc[index, 3])  # Ensure it's a string
        tafseer_text = str(verse_info.iloc[index, 4]) if choice == 3 else None

        response_data.append({
            "Surah Name": surah_name,
            "Verse Number": verse_number,
            "Verse": verse_text,
            "Tafseer": tafseer_text
        })

    return jsonify(response_data)


@app.route('/command', methods=['POST'])
def commands():
    data = request.get_json()
    sentence = data['sentence']
    ayah_number, surah = speech_recognizer(sentence)
    df = pd.read_excel('Tafseer.xlsx')
    file_path = 'surah.json'
    quran_surahs_data = load_quran_surahs(file_path)
    if quran_surahs_data:
        surah_index = map_surah_name_to_index(surah, quran_surahs_data)
        ayah = get_specific_ayah(df, surah_index, ayah_number)

    response_data = [{
        "input": sentence,
        "Surah Name": surah,
        "Verse Number": ayah_number,
        "ayah": ayah,
    }]
    return jsonify(response_data)


# model api isa
@app.route('/model', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    input_text = data['text']
    input_verse = data['verseNumber']
    features = preprocess(input_text)
    model = load_model('Lstm_model_100epochs.h5')
    last_dense_output = model.predict(features)
    top_N_verse = rank_N_verse(last_dense_output, input_verse)

    response_data = []

    for verse in top_N_verse:
        response_data.append({"ayah": verse})

    return jsonify(response_data)



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
    # app.run(debug=True)
    # app.run(host='0.0.0.0', port=5000)
