/*

1. game클래스

2. 캐릭터 클래스

3. 몬스터 클래스 
각 클래스 별 메서드 구현
*/

//기능 구현
/*
1. 파일로부터 데이터 읽어오기
  
  
2. 사용자로부터 캐릭터 입력받기

3.게임 종료 후 결과 파일에 저장하기

*/

// main 함수

import 'dart:io';

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
  String monsterName;
  int monsterHealth;
  int monsterAttackMax;
  int monsterAromr;

  Monster(
    this.monsterName,
    this.monsterHealth,
    this.monsterAttackMax,
    this.monsterAromr,
  );

  void attackCharacter(Character character) {
    //공격 메서드
  }

  void showStatus() {
    //상태를 출력하는 메서드
  }
}

void main() {}
