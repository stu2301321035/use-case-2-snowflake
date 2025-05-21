create database swan_zoo_db;

create table swan_zoo_db.PUBLIC.td_zooPark(
    record_id int autoincrement,
    zooInfo_json variant
)


insert into swan_zoo_db.PUBLIC.td_zooPark(zooInfo_json)
select TRY_PARSE_JSON('{
"zooName": "Cosmic Critters Galactic Zoo",
"location": "Space Station Delta-7, Sector Gamma-9",
"establishedDate": "2077-01-01",
"director": {
    "name": "Zorp Glorbax",
    "species": "Xylosian"
},
"habitats": [
    {
    "id": "H001",
    "name": "Crystal Caves",
    "environmentType": "Subterranean",
    "sizeSqMeters": 1500,
    "safetyRating": 4.5,
    "features": ["Luminescent Flora", "Geothermal Vents", "Echo Chambers"],
    "currentTempCelsius": 15
    },
    {
    "id": "H002",
    "name": "Azure Aquarium",
    "environmentType": "Aquatic",
    "sizeSqMeters": 3000,
    "safetyRating": 4.8,
    "features": ["Coral Reef Simulation", "High-Pressure Zone", "Bioluminescent Plankton"],
    "currentTempCelsius": 22
    },
    {
    "id": "H003",
    "name": "Floating Forest",
    "environmentType": "Zero-G Jungle",
    "sizeSqMeters": 2500,
    "safetyRating": 4.2,
    "features": ["Magnetic Vines", "Floating Islands", "Simulated Rain"],
    "currentTempCelsius": 28
    },
    {
    "id": "H004",
    "name": "Frozen Tundra",
    "environmentType": "Arctic",
    "sizeSqMeters": 1800,
    "safetyRating": 4.0,
    "features": ["Ice Caves", "Simulated Aurora"],
    "currentTempCelsius": -10
    }
],
"creatures": [
    {
    "id": "C001",
    "name": "Gloob",
    "species": "Gelatinoid",
    "originPlanet": "Xylar",
    "diet": "Photosynthesis",
    "temperament": "Docile",
    "habitatId": "H001",
    "acquisitionDate": "2077-01-15",
    "specialAbilities": null,
    "healthStatus": { "lastCheckup": "2077-03-01", "status": "Excellent" }
    },
    {
    "id": "C002",
    "name": "Finblade",
    "species": "Aqua-Predator",
    "originPlanet": "Neptunia Prime",
    "diet": "Carnivore",
    "temperament": "Aggressive",
    "habitatId": "H002",
    "acquisitionDate": "2077-02-01",
    "specialAbilities": ["Sonar Burst", "Camouflage"],
    "healthStatus": { "lastCheckup": "2077-03-10", "status": "Good" }
    },
    {
    "id": "C003",
    "name": "Sky-Wisp",
    "species": "Aether Flyer",
    "originPlanet": "Cirrus V",
    "diet": "Energy Absorption",
    "temperament": "Shy",
    "habitatId": "H003",
    "acquisitionDate": "2077-02-20",
    "specialAbilities": ["Invisibility", "Phase Shift"],
    "healthStatus": { "lastCheckup": "2077-03-15", "status": "Fair" }
    },
    {
    "id": "C004",
    "name": "Krystal Krawler",
    "species": "Silicate Arthropod",
    "originPlanet": "Xylar",
    "diet": "Mineralvore",
    "temperament": "Neutral",
    "habitatId": "H001",
    "acquisitionDate": "2077-03-05",
    "specialAbilities": ["Crystal Armor", "Burrowing"],
    "healthStatus": { "lastCheckup": "2077-03-20", "status": "Excellent" }
    },
    {
    "id": "C005",
    "name": "Ice Strider",
    "species": "Cryo-Mammal",
    "originPlanet": "Cryonia",
    "diet": "Herbivore",
    "temperament": "Docile",
    "habitatId": "H004",
    "acquisitionDate": "2077-03-10",
    "specialAbilities": ["Thermal Resistance", "Ice Skating"],
    "healthStatus": { "lastCheckup": "2077-03-25", "status": "Good"}
    }
],
"staff": [
    {
    "employeeId": "S001",
    "name": "Grunga",
    "role": "Senior Keeper",
    "species": "Gronk",
    "assignedHabitatIds": ["H001", "H004"]
    },
    {
    "employeeId": "S002",
    "name": "Dr. Elara Vance",
    "role": "Chief Veterinarian",
    "species": "Human",
    "assignedHabitatIds": []
    },
    {
    "employeeId": "S003",
    "name": "Bleep-Bloop",
    "role": "Maintenance Droid",
    "species": "Robotic Unit 7",
    "assignedHabitatIds": ["H002", "H003"]
    }
],
"upcomingEvents": [
    {
    "eventId": "E001",
    "name": "Finblade Feeding Frenzy",
    "type": "Feeding Show",
    "scheduledTime": "2077-04-01T14:00:00Z",
    "locationHabitatId": "H002",
    "involvedCreatureIds": ["C002"]
    },
    {
    "eventId": "E002",
    "name": "Sky-Wisp Visibility Demo",
    "type": "Educational",
    "scheduledTime": "2077-04-05T11:00:00Z",
    "locationHabitatId": "H003",
    "involvedCreatureIds": ["C003"]
    }
]
}');

select* from swan_zoo_db.PUBLIC.td_zooPark

--1
SELECT zooInfo_json['zooName'], zooinfo_json['location']
FROM swan_zoo_db.PUBLIC.td_zooPark


--2
SELECT zooInfo_json['director']:name, zooInfo_json['director']:species
FROM swan_zoo_db.PUBLIC.td_zooPark

--3
SELECT 
    c.value:name AS name,
    c.value:species AS species
FROM 
    swan_zoo_db.PUBLIC.td_zooPark,
    LATERAL FLATTEN(input => zooInfo_json['creatures']) AS c;

--4
SELECT 
    c.value:name AS name,
    c.value:originPlanet AS planet
FROM 
    swan_zoo_db.PUBLIC.td_zooPark,
    LATERAL FLATTEN(input => zooInfo_json['creatures']) AS c
where c.value:originPlanet  LIKE '%Xylar%'

--5
select 
    c.value: environmentType as Type,
    c.value:sizeSqMeters as Meters
from 
    swan_zoo_db.PUBLIC.td_zooPark,
    LATERAL FLATTEN(input => zooInfo_json['habitats']) AS c
where c.value:sizeSqMeters>2000

--6
SELECT 
    c.value: name AS name,
    c.value: specialAbilities AS Abilities
FROM 
    swan_zoo_db.public.td_zoopark, 
    LATERAL FLATTEN(input=>zooinfo_json['creatures']) AS c
WHERE
    ARRAY_CONTAINS('Camouflage':: VARIANT, c.value:specialAbilities);

--7
select 
    c.value: name as name,
    c.value: healthStatus as status
from
    swan_zoo_db.public.td_zoopark, 
    LATERAL FLATTEN(input=>zooinfo_json['creatures']) AS c
where c.value:healthStatus:status !='Excellent'

--8
select 
    c.value:name as Name,
    c.value:role as Role
from
    swan_zoo_db.public.td_zoopark,
    lateral flatten(input=>zooInfo_json['staff']) as c
where
    ARRAY_CONTAINS('H001'::VARIANT, c.value:assignedHabitatIds)

   
--9
select 
    c.value: habitatId as Id,
    count(*) as CreaturesCount
from
    swan_zoo_db.public.td_zoopark,
    lateral flatten(input=>zooinfo_json['creatures']) as c
group by
    c.value:habitatId
order by CreaturesCount desc;


--10
select DISTINCT f.value::string as UniqueFeatures
from
    swan_zoo_db.public.td_zoopark,
    lateral flatten(input=>zooinfo_json['habitats']) as h,
    lateral flatten(input=>h.value['features']) as f
order by
    UniqueFeatures

    
--11
select
    u.value: name as Name,
    u.value: type as Type,
    u.value:scheduledTime:: timestamp as Scheduled_Time
from 
    swan_zoo_db.public.td_zoopark,
    lateral flatten(input=>zooinfo_json['upcomingEvents']) as u
order by 
    Name


--12
select
    c.value: name as Creature_Name,
    h.value: environmentType as Environment_Type,
from
    swan_zoo_db.public.td_zoopark,
    lateral flatten(input=>zooinfo_json['creatures']) as c,
    lateral flatten(input=>zooinfo_json['habitats']) as h
where
    c.value: habitatId = h.value:id