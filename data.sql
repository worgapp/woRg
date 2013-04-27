
CREATE TABLE clothes (
  IDC INT DEFAULT NULL,
  IDU INT DEFAULT NULL,
  IDW INT DEFAULT NULL,
  availability bit(1) DEFAULT NULL,
  type INT DEFAULT NULL,
  formal INT DEFAULT NULL,
  rating INT DEFAULT NULL,
  primary_material INT DEFAULT NULL,
  secondary_material INT DEFAULT NULL,
  primary_color INT DEFAULT NULL,
  secondary_color INT DEFAULT NULL,
  primary_model INT DEFAULT NULL,
  secondary_model INT DEFAULT NULL,
  description varchar(100) DEFAULT NULL,
  photo varchar(100) DEFAULT NULL
);

INSERT INTO clothes VALUES (8,6,1,b'1',3,2,2,9,0,12,0,9,0,'',NULL),(9,6,1,b'1',12,2,5,9,0,13,0,5,0,'Ha!',NULL),(10,1,1,b'1',1,1,4,6,0,9,0,12,0,'My hat!','/imgs/kokcxuxycfgzzqehkaacksxl.jpg'),(11,1,1,b'1',12,1,4,6,0,16,0,16,0,'','/imgs/vfnodqnvjcktjifjixniynnn.jpg'),(12,1,1,b'1',3,1,2,8,0,16,0,14,0,'','/imgs/onttycisxpeowtscfgbpbnic.jpg'),(13,1,1,b'1',3,2,1,5,0,14,0,9,0,'','/imgs/blquoavutybftyblnxfydocl.jpg'),(14,1,1,b'1',11,0,4,8,0,12,0,15,0,'','http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image'),(15,1,1,b'1',11,0,4,8,0,12,0,15,0,'','http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image'),(16,1,1,b'1',10,1,2,5,0,9,0,17,0,'','/imgs/idjmswdyhwvynckeliwqriqv.jpg'),(17,1,2,b'1',3,1,5,1,0,12,0,14,0,'My favorite!','/imgs/kyzszbprmtwyhfedagsecujh.jpg');


CREATE TABLE clothes_type (
  ID INT DEFAULT NULL,
  name varchar(100) DEFAULT NULL,
  top bit(1) DEFAULT NULL
);


INSERT INTO clothes_type VALUES (0,'None',NULL),(1,'Hat','1'),(2,'Shirt','1'),(3,'T-shirt','1'),(4,'Undershirt','1'),(5,'Jacket','1'),(6,'Lounge jacket','1'),(7,'Jemmy','1'),(8,'Coat','1'),(9,'Scarf','1'),(10,'Gloves','1'),(11,'Belt','0'),(12,'Jeans','0'),(13,'Trousers','0'),(14,'Shorts','0'),(15,'Cloth pants','0'),(16,'Tracksuit','1'),(17,'Sandals','0'),(18,'Boots','0'),(19,'Snickers','0'),(20,'Flip-flops','0'),(21,'Shoes','0');


CREATE TABLE color_type (
  ID INT DEFAULT NULL,
  name varchar(100) DEFAULT NULL
);

INSERT INTO color_type VALUES (0,'None'),(1,'Red'),(2,'Orange'),(3,'Fuchsia'),(4,'Pink'),(5,'Magenta'),(6,'Light blue'),(7,'Azure'),(8,'Cyan'),(9,'Dark blue'),(10,'Yellow'),(11,'Denim'),(12,'Aqua marine'),(13,'Light green'),(14,'Apple green'),(15,'Dark green'),(16,'Light gray'),(17,'Dark gray'),(18,'Light brown'),(19,'Dark brown'),(20,'Purple'),(21,'Black'),(22,'White'),(23,'Unknown');

CREATE TABLE credentials (
  IDU INT DEFAULT NULL,
  username varchar(100) DEFAULT NULL,
  password varchar(100) DEFAULT NULL
);

INSERT INTO credentials VALUES (1,'ripanea@yahoo.com','e10adc3949ba59abbe56e057f20f883e'),(2,'caushinina@gmail.com','25f9e794323b453885f5181f1b624d0b'),(3,'radas@asdas.ads','7815696ecbf1c96e6894b779456d330e'),(4,'stoica.razvan_andrei@yahoo.com','2f621013e3ceeeb226db2c4c47f57bf8');

CREATE TABLE current_users (
  ID INT DEFAULT NULL,
  token varchar(50) DEFAULT NULL
);

INSERT INTO current_users VALUES (1,'kdoufaqqgjrewocwhoiodnmo'),(1,'dpkmlikqalqrjmgaaybrdewv'),(1,'cygkztfzyxfgmoycwhzqvftr'),(1,'wodwwhuwbotxqtnumjdwhlsn'),(1,'pomdvgmisdjdoadpirbvlvwa'),(1,'xyzfzzmvhkshbhxcaywxvpks'),(5,'lnijcnzdbvflycwbijkcfxos'),(6,'ymczsbszzbgydbrbozuvanvr'),(1,'pqcdjraltsbknseigejyjqfy'),(1,'rxikxbjmkfbxwjocsxzcgblk'),(1,'fxebfsefekxfdijnklmiaiui'),(1,'mhuruoosfruvyjiexrupozuu'),(1,'xiqzmscngfxybjiurwtpqjhf');

CREATE TABLE formality_type (
  ID INT DEFAULT NULL,
  name varchar(100) DEFAULT NULL
);

INSERT INTO formality_type VALUES (0,'Informal'),(1,'Semi-formal'),(2,'Formal');

CREATE TABLE material_type (
  ID INT DEFAULT NULL,
  name varchar(100) DEFAULT NULL
);

INSERT INTO material_type VALUES (0,'None'),(1,'Cotton'),(2,'Wool'),(3,'Polyester'),(4,'Silk'),(5,'Fur'),(6,'Elastane'),(7,'Natural fibers'),(8,'Cloth'),(9,'Leather'),(10,'Unknown');

CREATE TABLE model_type (
  ID INT DEFAULT NULL,
  name varchar(100) DEFAULT NULL
);

INSERT INTO model_type VALUES (0,'None'),(1,'Small dots'),(2,'Large dots'),(3,'Horizontal thin stripes'),(4,'Horizontal thick stripes'),(5,'Vertical thin stripes'),(6,'Vertical thick stripes'),(7,'Inclined thin stripes'),(8,'Inclined thick stripes'),(9,'Geometrical shapes'),(10,'Plain'),(11,'Spots'),(12,'Text front'),(13,'Text back'),(14,'Number front'),(15,'Number back'),(16,'Image front'),(17,'Image back'),(18,'Unknown');

CREATE TABLE profiles (
  IDU INT DEFAULT NULL,
  color_priority varchar(11) DEFAULT NULL,
  model_priority varchar(11) DEFAULT NULL,
  material_priority varchar(11) DEFAULT NULL
);

INSERT INTO profiles VALUES (1,'20,7,0','1,11,0','1,2,0');

CREATE TABLE users (
  IDU INT DEFAULT NULL,
  first_name varchar(100) DEFAULT NULL,
  last_name varchar(100) DEFAULT NULL,
  is_admin bit(1) DEFAULT NULL,
  sex bit(1) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  birthdate varchar(12) DEFAULT NULL
);

INSERT INTO users VALUES (1,'Razvan','Panea',b'1',b'0','ripanea@yahoo.com','1992-08-31'),(2,'Nina','Caushi',b'0',b'1','caushinina@gmail.com','1993-11-17'),(3,'Dan','Dan',b'0',b'0','radas@asdas.ads','2013-01-24'),(4,'Andrei','Stoica',b'0',b'0','stoica.razvan_andrei@yahoo.com','1992-03-17');

CREATE TABLE wardrobe (
  IDW INT DEFAULT NULL,
  IDU INT DEFAULT NULL,
  name varchar(100) DEFAULT NULL
);

INSERT INTO wardrobe VALUES (1,4,'Jacobs'),(2,4,'Work'),(1,6,'Home'),(1,1,'Home'),(2,1,'Away');

