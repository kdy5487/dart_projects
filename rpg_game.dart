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
String getCharacterName() {}

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

class Character {
  String name;
  int health;

  int attack;
  int aromr;

  Character(this.name, this.health, this.attack, this.aromr);

  void attackMonster(Monster monster) {
    //공격 매서드
  }

  void defend() {
    //방어 메서드
  }
  void showStatus() {
    //상태를 출력하는 메서드
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

void main() {}
