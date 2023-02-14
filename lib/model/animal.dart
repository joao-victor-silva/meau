import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  String? id;
  String? name;
  AnimalState? state;
  AnimalSpecie? specie;
  AnimalGender? gender;
  AnimalSize? size;
  AnimalAge? age;
  List<AnimalBehavior>? behaviors;
  List<AnimalHealth>? healths;
  List<AnimalAdoptRequirement>? adoptRequirements;
  String? illness;
  String? about;
  List<String>? photoUrls;
  String? ownerId;

  Animal({
    this.id,
    this.name,
    this.state,
    this.specie,
    this.gender,
    this.size,
    this.age,
    this.behaviors,
    this.healths,
    this.adoptRequirements,
    this.illness,
    this.about,
    this.photoUrls,
    this.ownerId,
  });

  Animal.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    name = map['name'];
    state = map['state'] != null ? AnimalState.values.byName(map['state']) : null;
    specie = map['specie'] != null ? AnimalSpecie.values.byName(map['specie']) : null;
    gender = map['specie'] != null ? AnimalGender.values.byName(map['gender']) : null;
    size = map['size'] != null ? AnimalSize.values.byName(map['size']) : null;
    age = map['age'] != null ? AnimalAge.values.byName(map['age']) : null;
    behaviors = map['behaviors'] != null ? (map['behaviors'] as List)?.map((e) => AnimalBehavior.values.byName(e as String))?.toList() : null;
    healths = map['healths'] != null ? (map['healths'] as List)?.map((e) => AnimalHealth.values.byName(e as String))?.toList() : null;
    adoptRequirements = map['adoptRequirements']!= null ? (map['adoptRequirements'] as List)?.map((e) => AnimalAdoptRequirement.values.byName(e as String))?.toList() : null;
    illness = map['illness'];
    about = map['about'];
    photoUrls = map['photoUrls'] != null ? (map['photoUrls'] as List)?.map((item) => item as String)?.toList() : null;
    ownerId = map['ownerId'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "state": state?.name,
      "specie": specie?.name,
      "gender": gender?.name,
      "size": size?.name,
      "age": age?.name,
      "behaviors": behaviors?.map((e) => e.name).toList(),
      "healths": healths?.map((e) => e.name).toList(),
      "adoptRequirements": adoptRequirements?.map((e) => e.name).toList(),
      "illness": illness,
      "about": about,
      "photoUrls": photoUrls,
      "ownerId": ownerId,
    };
  }
}

enum AnimalState {
  adopted,
  helped,
  sponsored,
  toAdopt,
  toHelp,
  toSponsor,
}

enum AnimalSpecie {
  cat,
  dog,
}

String animalSpecieTranslate(AnimalSpecie? specie) {
  if (specie == null) {
    return "";
  }

  switch (specie) {
    case AnimalSpecie.cat:
      return "Gato";
    case AnimalSpecie.dog:
      return "Cachorro";
  }
}

enum AnimalGender {
  female,
  male,
}

String animalGenderTranslate(AnimalGender? gender) {
  if (gender == null) {
    return "";
  }

  switch (gender) {
    case AnimalGender.female:
      return "Fêmea";
    case AnimalGender.male:
      return "Macho";
  }
}

enum AnimalSize {
  small,
  medium,
  big,
}

String animalSizeTranslate(AnimalSize? size) {
  if (size == null) {
    return "";
  }

  switch (size) {
    case AnimalSize.small:
      return "Pequeno";
    case AnimalSize.medium:
      return "Médio";
    case AnimalSize.big:
      return "Grande";
  }
}

enum AnimalAge {
  young,
  adult,
  old,
}


String animalAgeTranslate(AnimalAge? age) {
  if (age == null) {
    return "";
  }

  switch (age) {
    case AnimalAge.young:
      return "Filhote";
    case AnimalAge.adult:
      return "Adulto";
    case AnimalAge.old:
      return "Idoso";
  }
}

enum AnimalBehavior {
  playful,
  shy,
  calm,
  watchful,
  loving,
  lazy
}

String animalBehaviorTranslate(AnimalBehavior? behavior) {
  if (behavior == null) {
    return "";
  }

  switch (behavior) {
    case AnimalBehavior.playful:
      return "Brincalhão";
    case AnimalBehavior.shy:
      return "Tímido";
    case AnimalBehavior.calm:
      return "Calmo";
    case AnimalBehavior.watchful:
      return "Guarda";
    case AnimalBehavior.loving:
      return "Amoroso";
    case AnimalBehavior.lazy:
      return "Preguiçoso";
  }
}

enum AnimalHealth {
  vaccinated,
  dewormed,
  castrated,
  sick,
}

String animalHealthTranslate(AnimalHealth? health) {
  if (health == null) {
    return "";
  }

  switch (health) {
    case AnimalHealth.vaccinated:
      return "Vacinado";
    case AnimalHealth.dewormed:
      return "Vermifugado";
    case AnimalHealth.castrated:
      return "Castrado";
    case AnimalHealth.sick:
      return "Doente";
  }
}

enum AnimalAdoptRequirement {
  adoptTerm,
  housePhotos,
  previousVisitToTheAnimal,
  postAdoptionFollowUps,
}

String animalAdoptRequirementTranslate(AnimalAdoptRequirement? requirement) {
  if (requirement == null) {
    return "";
  }

  switch (requirement) {
    case AnimalAdoptRequirement.adoptTerm:
      return "Termo de adoção";
    case AnimalAdoptRequirement.housePhotos:
      return "Fotos da casa";
    case AnimalAdoptRequirement.previousVisitToTheAnimal:
      return "Visita prévia ao animal";
    case AnimalAdoptRequirement.postAdoptionFollowUps:
      return "Acompanhamento pós adoção";
  }
}

enum AnimalNeed {
  food,
  financialAssistance,
  medicine,
  object,
}
