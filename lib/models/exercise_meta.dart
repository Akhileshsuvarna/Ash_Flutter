//  This class contains meta information of Exercises

class ExerciseMeta {
  ExerciseMeta(this.title, this.description, this.coverImageUrl,
      this.isARAvailable, this.isVideoAvailable);
  String title;
  String description;
  bool isARAvailable;
  bool isVideoAvailable;
  String? coverImageUrl;
}
