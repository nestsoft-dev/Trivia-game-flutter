// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuestionModel {
  final int id;
  final String question;
  final Option option;
  final String section;
  final String image;
  final String answer;
  final String solution;
  final String examtype;
  final String examyear;
  final dynamic questionNub;
  final int hasPassage;
  final String category;
  QuestionModel({
    required this.id,
    required this.question,
    required this.option,
    required this.section,
    required this.image,
    required this.answer,
    required this.solution,
    required this.examtype,
    required this.examyear,
    required this.questionNub,
    required this.hasPassage,
    required this.category,
  });



  QuestionModel copyWith({
    int? id,
    String? question,
    Option? option,
    String? section,
    String? image,
    String? answer,
    String? solution,
    String? examtype,
    String? examyear,
    dynamic? questionNub,
    int? hasPassage,
    String? category,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      option: option ?? this.option,
      section: section ?? this.section,
      image: image ?? this.image,
      answer: answer ?? this.answer,
      solution: solution ?? this.solution,
      examtype: examtype ?? this.examtype,
      examyear: examyear ?? this.examyear,
      questionNub: questionNub ?? this.questionNub,
      hasPassage: hasPassage ?? this.hasPassage,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'option': option.toMap(),
      'section': section,
      'image': image,
      'answer': answer,
      'solution': solution,
      'examtype': examtype,
      'examyear': examyear,
      'questionNub': questionNub,
      'hasPassage': hasPassage,
      'category': category,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as int,
      question: map['question'] as String,
      option: Option.fromMap(map['option'] as Map<String,dynamic>),
      section: map['section'] as String,
      image: map['image'] as String,
      answer: map['answer'] as String,
      solution: map['solution'] as String,
      examtype: map['examtype'] as String,
      examyear: map['examyear'] as String,
      questionNub: map['questionNub'] as dynamic,
      hasPassage: map['hasPassage'] as int,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) => QuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestionModel(id: $id, question: $question, option: $option, section: $section, image: $image, answer: $answer, solution: $solution, examtype: $examtype, examyear: $examyear, questionNub: $questionNub, hasPassage: $hasPassage, category: $category)';
  }

  @override
  bool operator ==(covariant QuestionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.question == question &&
      other.option == option &&
      other.section == section &&
      other.image == image &&
      other.answer == answer &&
      other.solution == solution &&
      other.examtype == examtype &&
      other.examyear == examyear &&
      other.questionNub == questionNub &&
      other.hasPassage == hasPassage &&
      other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      question.hashCode ^
      option.hashCode ^
      section.hashCode ^
      image.hashCode ^
      answer.hashCode ^
      solution.hashCode ^
      examtype.hashCode ^
      examyear.hashCode ^
      questionNub.hashCode ^
      hasPassage.hashCode ^
      category.hashCode;
  }
}


class Option {
  final String a;
  final String b;
  final String c;
  final String d;
  final String e;
  Option({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
  });



  Option copyWith({
    String? a,
    String? b,
    String? c,
    String? d,
    String? e,
  }) {
    return Option(
      a: a ?? this.a,
      b: b ?? this.b,
      c: c ?? this.c,
      d: d ?? this.d,
      e: e ?? this.e,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'e': e,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      a: map['a'] as String,
      b: map['b'] as String,
      c: map['c'] as String,
      d: map['d'] as String,
      e: map['e'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Option.fromJson(String source) => Option.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Option(a: $a, b: $b, c: $c, d: $d, e: $e)';
  }

  @override
  bool operator ==(covariant Option other) {
    if (identical(this, other)) return true;
  
    return 
      other.a == a &&
      other.b == b &&
      other.c == c &&
      other.d == d &&
      other.e == e;
  }

  @override
  int get hashCode {
    return a.hashCode ^
      b.hashCode ^
      c.hashCode ^
      d.hashCode ^
      e.hashCode;
  }
}
