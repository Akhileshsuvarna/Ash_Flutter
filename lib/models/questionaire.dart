class Questionaire {
  late int? age;
  late int? height;
  late int? weight;
  late String? gender;
  late String? numberOfAreasOfConcerns;
  late String? areasOfConcern;
  late String? painDuration;
  late String? firstTimeOrOngoing;
  late String? levelOfActivity;
  late String? nonExercisingReason;

  Questionaire({
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.numberOfAreasOfConcerns,
    this.areasOfConcern,
    this.painDuration,
    this.firstTimeOrOngoing,
    this.levelOfActivity,
    this.nonExercisingReason,
  });

  toJson() => {
        "age": age,
        "height": height,
        "weight": weight,
        "gender": gender,
        "numberOfAreasOfConcerns": numberOfAreasOfConcerns,
        "areasOfConcern": areasOfConcern,
        "painDuration": painDuration,
        "firstTimeOrOngoing": firstTimeOrOngoing,
        "levelOfActivity": levelOfActivity,
        "nonExercisingReason": nonExercisingReason
      };
}
