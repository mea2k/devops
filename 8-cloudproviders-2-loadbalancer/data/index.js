const express = require('express');
const serverless = require('serverless-http');
const md5 = require('md5');
const fs = require('fs');


// хранилище
const fileName = process.env.DATA_FILE || 'data.json'

let STORAGE = [];

try {
	STORAGE = JSON.parse(fs.readFileSync(fileName, 'utf8')) || [];
} catch (e) {
	//
}

function saveData() {
	try {
		let json = JSON.stringify(STORAGE)
		fs.writeFileSync(fileName, json);
	} catch (e) {
		//this.storage = [];
	}
	//console.log({...this.storage})
}


/////////////////////////////////////////////////
/////////////////////////////////////////////////

// Создание объекта Express.JS
const app = express()
app.use(express.json())

app.use(express.urlencoded({ extended: true }));




/////////////////////////////////////////////////
/////////////////////////////////////////////////
// обработчики URL-путей

// информация
app.get('/', (req, res) => {
	res.send('Hallo world');
});

// информация
app.get('/api/info', (req, res) => {
	res.json({
		data: 'It works!',
		author: 'Eugene'
	})
});

app.get('/api/load', (req, res) => {
	const publicKey = process.env.MARVEL_PUBLIC_KEY || '';
	const privateKey = process.env.MARVEL_PRIVATE_KEY || '';
	const timestamp = new Date().getTime().toString();
	const hash = md5(timestamp + privateKey + publicKey);

	const apiUrl = `http://gateway.marvel.com/v1/public/characters?ts=${timestamp}&apikey=${publicKey}&hash=${hash}`;

	fetch(apiUrl).then((data) => data.json().then((jData) => {
		let count = 0
		for (let v of (jData?.data?.results || [])) {
			if (STORAGE.some((item) => item.id == v.id))
				continue;
			STORAGE.push(v);
			count++;
		}

		saveData();

		res.status(200);
		res.json({
			size: STORAGE?.length || 0
		})
	}));
});

app.get('/api/characters', (req, res) => {
	const { id } = req.query

	let data = undefined;
	if (id) {
		// получение информации о персонаже с ID
		const publicKey = process.env.MARVEL_PUBLIC_KEY || '';
		const privateKey = process.env.MARVEL_PRIVATE_KEY || '';
		const timestamp = new Date().getTime().toString();
		const hash = md5(timestamp + privateKey + publicKey);

		const apiUrl = `http://gateway.marvel.com/v1/public/characters/${id}?ts=${timestamp}&apikey=${publicKey}&hash=${hash}`;

		fetch(apiUrl).then((data) => data.json().then((jData) => {
			console.log(jData)
			if (jData?.data?.results) {
				res.status(200);
				res.json(jData.data.results);
			} else {
				res.status(404);
				res.json({
					errcode: 404,
					errmsg: 'data not found'
				})
			}
		}));

	} else {
		// получение информации о всех персонажах
		res.json(STORAGE);
	}
});


// const PORT = process.env.PORT || 3000
// app.listen(PORT, () => {
// 	console.log('Server started at port ' + PORT + '.')
// })

/////////////////////////////////////////////////
/////////////////////////////////////////////////

module.exports.handler = serverless(app);

