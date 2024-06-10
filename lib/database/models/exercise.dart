class Exercise {
  late String name;
  late String bodyPart;
  late String equipment;
  late String target;
  late List<String> secondaryMuscles;
  late List<String> instructions;
  late String id;

  Exercise.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    bodyPart = data['bodyPart'];
    equipment = data['equipment'];
    target = data['target'];
    secondaryMuscles = List<String>.from(data['secondaryMuscles']);
    instructions = List<String>.from(data['instructions']);
    id = data['id'];
  }

  @override
  String toString() {
    return 'Exercise: {name: $name, bodyPart: $bodyPart, equipment: $equipment, targetMuscle: $target, secondaryMuscles: $secondaryMuscles, instructions: $instructions, id: $id}';
  }
}
