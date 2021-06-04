const geolib = require('geolib');

const pucLocations = [
  {
    name: "PUC Minas - Praça da Liberdade",
    latitude: "-19.933076864982805",
    longitude: "-43.93718058940618"
  },
  {
    name: "PUC Minas - Coração Eucarístico",
    latitude: "-19.9223422686867",
    longitude: "-43.992654385662156"
  },
  {
    name: "PUC Minas - Barreiro",
    latitude: "-19.973647077370412",
    longitude: "-44.026408351592465"
  },
  {
    name: "PUC Minas - São Gabriel",
    latitude: "-19.859092672098487",
    longitude: "-43.918941432110174"
  },
  {
    name: "PUC Minas - Betim",
    latitude: "-19.954809655456927",
    longitude: "-44.19850111083359"
  },
  {
    name: "PUC Minas - Contagem",
    latitude: "-19.93890905920093",
    longitude: "-44.07610044957403"
  },
  {
    name: "PUC Minas - Poços de Caldas",
    latitude: "-21.79892128070157",
    longitude: "-46.598409818687166"
  },
  {
    name: "PUC Minas - Arcos",
    latitude: "-20.298590123850715",
    longitude: "-45.54313892470359"
  },
  {
    name: "PUC Minas - Serro e Guanhães",
    latitude: "-18.606201504887512",
    longitude: "-43.38378913213457"
  },
  {
    name: "PUC Minas - Uberlândia",
    latitude: "-18.923944353125172",
    longitude: "-48.29535125911483"
  },
]

function isCloseToPuc(coordinates){
  let distance;
  let foundLocationName = "false";
  pucLocations.forEach(location => {
    distance = geolib.getDistance(location, coordinates);
    if (distance <= 100){
      foundLocationName = location.name;
    }
  })
  return foundLocationName;
}

exports.amICloseToPuc = (req, res) => {
  let coordinates = req.body.coordinates;
  res.status(200).send(isCloseToPuc(coordinates));
};

