/*
파일로부터 데이터 읽어오기
  캐릭터 데이터
  몬스터 데이터
사용자 입력 받기

게임 종료 후 결과 파일에 저장하기
*/

/*
1. game클래스
2. 캐릭터 클래스
3. 몬스터 클래스 
각 클래스 별 메서드 구현
*/

// main 함수

import 'dart:io';
import 'dart:math';

void loadCharacterStats() {
  try {
    final file = File('characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    String name = getCharacterName();
    character = Character(name, health, attack, defense);
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

//캐릭터 이름 입력받기
String getCharacterName() {
  while (true) {
    //리턴낼 때까지 반복

    print('캐릭터의 이름을 입력하세요');
    String? name = stdin.readLineSync(); //사용자의 입력을 받아 name으로
    if (name == null) {
      //null값일시에(공백)
      print('이름을 다시 입력하세요');
      continue; //공백아닐 때 까지 다시 반복
    } else if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
      //정규표현식으로 특수문자와 숫자 포함하지않게함.
      print('이름에는 숫자나 특수문자를 포함할 수 없습니다');
      continue; //숫자나 특수문자 포함안할떄까지 반복
    }
    return name;
  }
}

// 몬스터 데이터를 로드하는 함수
List<Monster> loadMonsters() {
  List<Monster> monsters = [];
  try {
    final file = File('monsters.txt');
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final stats = line.split(',');

      if (stats.length != 3) continue;

      String name = stats[0];
      int health = int.parse(stats[1]);
      int maxAttack = int.parse(stats[2]);
      int armor = 0;

      monsters.add(Monster(name, health, maxAttack, armor));
    }
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
  return monsters;
}

class Character {
  String name;
  int health;

  int attack;
  int aromr;

  Character(this.name, this.health, this.attack, this.aromr);

  void attackMonster(Monster monster) {
    //공격 매서드
    int damage = max(attack - monster.aromr, 0); //캐릭터가 입히는 대미지== 공격력-몬스터방어력(0)
    monster.health -= damage;
    print('$name이 ${monster.name}에게 $damage의 피해를 입혔습니다.');
  }

  void defend() {
    //방어 메서드
    //몬스터가 입힌 대미지만큼 회복
    int heal = 0; //몬스터대미지 함수에서 추후 작성
    health += heal;
    print('$name이 방어에 성공하여 $heal만큼 회복되었습니다.');
  }

  void showStatus() {
    //상태를 출력하는 메서드(이름 - 체력,공격력,방어력)
    print('$name - 체력: $health, 공격력: $attack, 방어력: $aromr');
  }
}

class Monster {
  String name;
  int health;
  int maxAttack;
  int aromr;

  Monster(this.name, this.health, this.maxAttack, this.aromr);

  void attackCharacter(Character character) {
    //공격 메서드
  }

  void showStatus() {
    //상태를 출력하는 메서드
  }
}

//게임 클래스 정의
class Game {
  //속성 정의
  String Character; //캐릭터
  List<Monster> monster = []; //몬스터
  int monsterCount; //물리친 몬스터 개수

  Game(this.Character, this.monster, this.monsterCount); //매개변수 생성자, this 필수

  //반복문을 사용하여 몬스터를 랜덤으로 뽑아 순회하면서 대결
  void startGame() {
    print('게임을 시작합니다!');
    //캐릭터이름 - 체력 공격력 방어력  출
  }

  void battle() {}
  void getRandomMonster() {}
}

void main() {}
