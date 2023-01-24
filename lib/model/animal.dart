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
  List<AnimalSponsorshipRequirement>? sponsorshipRequirements;
  List<AnimalNeed>? needs;
  String? medicines;
  String? objects;
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
    this.sponsorshipRequirements,
    this.needs,
    this.medicines,
    this.objects,
    this.about,
    this.photoUrls,
    this.ownerId,
  });

  Animal.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    // TODO: update the order enum like the specie and gender
    id = map['id'];
    name = map['name'];
    state = map['state'];
    specie = AnimalSpecie.values.byName(map['specie']);
    gender = AnimalGender.values.byName(map['gender']);
    size = map['size'];
    age = map['age'];
    behaviors = map['behaviors'];
    healths = map['healths'];
    sponsorshipRequirements = map['sponsorshipRequirements'];
    needs = map['needs'];
    medicines = map['medicines'];
    objects = map['objects'];
    about = map['about'];
    photoUrls = (map['photoUrls'] as List)?.map((item) => item as String)?.toList();
    ownerId = map['ownerId'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "state": state,
      "specie": specie?.name,
      "gender": gender?.name,
      "size": size,
      "age": age,
      "behaviors": behaviors,
      "healths": healths,
      "sponsorshipRequirements": sponsorshipRequirements,
      "needs": needs,
      "medicines": medicines,
      "objects": objects,
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

enum AnimalGender {
  female,
  male,
}

enum AnimalSize {
  small,
  medium,
  big,
}

enum AnimalAge {
  young,
  adult,
  old,
}

enum AnimalBehavior { playful, shy, calm, watchful, loving, lazy }

enum AnimalHealth {
  vaccinated,
  dewormed,
  castrated,
  sick,
}

enum AnimalSponsorshipRequirement {
  sponsorshipTerm,
  financilAssistence,
  financilAssistenceFood,
  financilAssistenceHealth,
  financilAssistenceObject,
  visitsToTheAnimal,
}

enum AnimalNeed {
  food,
  financilAssistence,
  medicine,
  object,
}
