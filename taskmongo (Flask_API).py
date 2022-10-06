from flask import Flask ,request,jsonify
import pymongo

app = Flask(__name__)

client = pymongo.MongoClient("mongodb+srv://19rizvee-hasan:sudhanshu@cluster0.uklzo7x.mongodb.net/?retryWrites=true&w=majority")
db = client.test
database = client['taskdb']
collection = database['taskcollection']

@app.route("/insert/mongo" , methods=['POST'])
def insert():
    if request.method == 'POST':
        name = request.json['name']
        number = request.json['number']
        collection.insert_one({name:number})
        return jsonify(str("succefully inserted "))

if __name__ =='__main__':
    app.run()

