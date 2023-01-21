class AnimalModel {
  String? id;
  String? name;
  AnimalState? state;
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

  AnimalModel({
    this.id,
    this.name,
    this.state,
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

  AnimalModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    name = map['name'];
    state = map['state'];
    gender = map['gender'];
    size = map['size'];
    age = map['age'];
    behaviors = map['behaviors'];
    healths = map['healths'];
    sponsorshipRequirements = map['sponsorshipRequirements'];
    needs = map['needs'];
    medicines = map['medicines'];
    objects = map['objects'];
    about = map['about'];
    photoUrls = map['photoUrls'];
    ownerId = map['ownerId'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "state": state,
      "gender": gender,
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
