import 'dart:io';
import 'dart:math';

//캐릭터 데이터 로드
Character loadCharacterStats() {
  try {
    final file = File('characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    String name = getCharacterName();
    return Character(name, health, attack, defense);
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다dd: $e');
    exit(1);
  }
}

// 몬스터 데이터를 로드하는 함수
List<Monster> loadMonstersStats() {
  List<Monster> monsters = [];
  try {
    final file = File('monsters.txt');
    List<String> lines = file.readAsLinesSync();

    for (String line in lines) {
      List<String> data = line.split(',');

      if (data.length != 3) continue;

      String name = data[0];
      int health = int.parse(data[1]);
      int maxAttack = int.parse(data[2]);
      int armor = 0;

      monsters.add(Monster(name, health, maxAttack, armor));
    }
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
  return monsters;
}

//캐릭터 이름 입력받기
String getCharacterName() {
  while (true) {
    //리턴낼 때까지 반복

    print('캐릭터의 이름을 입력하세요');
    String? name = stdin.readLineSync()?.trim(); //사용자의 입력을 받아 name으로
    if (name == null || name.isEmpty) {
      //null값일시에(공백)
      print('이름을 다시 입력하세요');
      continue; //공백아닐 때 까지 다시 반복
    }
    if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
      //정규표현식으로 특수문자와 숫자 포함하지않게함.
      print('이름에는 숫자나 특수문자를 포함할 수 없습니다');
      continue; //숫자나 특수문자 포함안할떄까지 반복
    }
    return name;
  }
}

class Character {
  String name;
  int health;
  int attack;
  int armor;

  int lives; //목숨 추가

  bool itemUsed = false; // 아이템 사용 여부

  int originalAttack; // 아이템 사용후 원래 공격력으로 돌아가기위함.

  Character(this.name, this.health, this.attack, this.armor)
    : originalAttack = attack,
      lives = 1; //생성자에 원래 공격력 저장함.

  void attackMonster(Monster monster) {
    //공격 매서드
    int damage = max(attack - monster.armor, 0); //캐릭터가 입히는 대미지== 공격력-몬스터방어력(0)
    monster.health = max(0, monster.health - damage); //체력이 0미만으로 가는 현상을 막기위함
    print('$name이 ${monster.name}에게 $damage의 피해를 입혔습니다.');

    if (itemUsed) {
      //몬스터 때린 후 itemUsed를 통해 아이템을 사용했는지 판별.
      attack = originalAttack; //아이템 효과가 끝나면 원래 공격력으로 복구
      print('아이템 효과가 끝났습니다. 공격력이 원래대로 돌아왔습니다: $attack');
    }
  }

  void gambleAttackMonster(Monster monster) {
    Random random = Random();
    double chance = random.nextDouble();
    int damage = attack;

    if (chance < 0.25) {
      damage *= 3; //25퍼 확률로 대미지 3배
      print('도박 대성공! 강력한 공격으로 $damage의 피해를 줍니다.');
    } else if (chance < 0.5) {
      damage *= 2; //25퍼 대미지 2배
      print('도박 성공! $damage의 피해를 줍니다.');
    } else {
      health -= damage; //25퍼 자해대미지
      print('도박 실패! $damage의 피해를 받습니다.');
    }
    monster.health -= damage;
  }

  void defend(Monster monster) {
    //방어 메서드
    //몬스터가 입힌 대미지만큼 회복
    int heal = monster.maxAttack;
    health += heal;
    print('$name이 방어에 성공하여 $heal만큼 회복되었습니다.');
  }

  void showStatus() {
    //상태를 출력하는 메서드(이름 - 체력,공격력,방어력)
    print('$name - 체력: $health, 공격력: $attack, 방어력: $armor');
  }

  //전투 시 캐릭터의 아이템 사용 기능 추가
  void useItem() {
    if (itemUsed) {
      //아이템을 단 한번이라도 사용했다면
      print('이미 아이템을 사용했습니다!');
      return; //메서드 종료
    } else {
      // 아이템을 사용안했다면
      attack *= 2;
      print('특수 아이템을 사용했습니다. 이번 턴 공격력 증가: $attack');
      itemUsed = true; //한번사용시 사용불가능으로
    }
  }
}

class Monster {
  //몬스터 속성
  String name;
  int health;
  int maxAttack;
  //몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없음. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최댓값으로 설정.
  int armor; //몬스터 방어력 = 0 >> 3턴마다 2씩 증가하게
  int trunCounter = 0; //방어력이 증가하였는지 확인할 카운터 변수

  Monster(this.name, this.health, this.maxAttack, this.armor);
  @override
  String toString() {
    return name;
  }

  void attackCharacter(Character character) {
    //공격 메서드
    int attack = max(Random().nextInt(maxAttack) + 1, character.armor);
    //몬스터 공격력과 캐릭터 방어력 중 높은 값
    int damage = max(attack - character.armor, 1); //최소 데미지 1 보장.

    character.health = max(0, character.health - damage); //체력이 0미만으로 되지않기위함,
    print('$name이 ${character.name}에게 $damage의 피해를 입혔습니다');
  }

  void showStatus() {
    //상태를 출력하는 메서드(이름 - 체력,공격력)
    print('$name - 체력: $health, 공격력: $maxAttack, 방어력: $armor');
  }

  void increaseDefense() {
    if (++trunCounter % 3 == 0) {
      //3턴마다 턴카운터 증가
      armor += 2; // 아머는 2씩 증가
      print('$name의 방어력이 증가했습니다! 현재 방어력: $armor');
    }
  }
}

//게임 클래스 정의
class Game {
  //속성 정의
  Character character; //캐릭터클래스의 매개변수 캐릭터 생성
  List<Monster> monsters = []; //몬스터와서 몬스터즈 리스트 생성
  int monsterCount = 0; //물리친 몬스터 개수, 처음엔 0

  Game(this.character, this.monsters); //매개변수 생성자

  //반복문을 사용하여 몬스터를 랜덤으로 뽑아 순회하면서 대결
  void startGame() {
    print('\n게임을 시작합니다!');

    //출력 이쁘게 만들기
    print('----------- 캐릭터 정보 -----------');
    character.showStatus(); // 처음에 플레이어 스탯 출력
    print('-----------------------------------');
    //몬스터 등장 반복
    int monstersLength = monsters.length; //반복 전 몬스터마리 수 체크
    while (character.health > 0 && monsterCount < monstersLength) {
      //게임 종료 조건과 반대(캐릭터의 체력이 0초과, 몬스터가 남아있는경우)
      Monster monster = getRandomMonster();
      print('\n새로운 몬스터 ${monster.name}이(가) 등장했습니다.');
      monster.showStatus(); // 몬스터 스탯 출력
      print('---------------------------------');

      battle(monster); //몬스터와 대결

      if (monsterCount == monstersLength) {
        //대결이 끝날 떄 몬스터를 다 잡을시 승리
        print('축하합니다. 모든 몬스터를 물리쳤습니다!'); //승리멘트
        break; //승리해서 게임종료
      }

      if (character.health <= 0 && character.lives == 0) {
        //체력 0 이하시 게임 종료
        print('당신은 죽었습니다. 남아있는 코인이 없습니다. 게임 오버!'); //패배멘트
        break; //죽어서 게임종료
      } else if (character.health <= 0 && character.lives > 0) {
        //죽었지만, 목숨이 남아있을 때
        character.lives--; //목숨 차감
        print('\n${character.name}이(가) 쓰러졌습니다. 코인을 사용하여 재도전합니다.\n');
        main(); //게임 다시시작
      }
      // 다음 전투 여부 확인
      print("\n다음 몬스터와 대결하시겠습니까? (y/n)");
      String? choice = stdin.readLineSync();
      if (choice?.toLowerCase() == 'y') {
        continue; //배틀이 한번끝나고 대결을 원할시
      }
      if (choice?.toLowerCase() == 'n') {
        print("게임을 종료합니다."); //도망
        break; //배틀의사가 없을시 게임종료
      }
    }
  }

  Monster getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  void battle(Monster monster) {
    while (character.health > 0 && monster.health > 0) {
      print('\n===== ${character.name}의 턴 =====');
      print('행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용 4. 럭키펀치)');
      String? input = stdin.readLineSync(); //공격 방어 사용자 입력

      if (input == '1') {
        character.attackMonster(monster);
      } else if (input == '2') {
        character.defend(monster);
      } else if (input == '3') {
        character.useItem();
        if (character.itemUsed) {
          continue; // 아이템을 사용한 경우 턴 진행
        } else {
          // 아이템 사용이 거부된 경우 (이미 사용함), 턴 유지
          continue;
        }
      } else if (input == '4') {
        character.gambleAttackMonster(monster);
      } else {
        print('해당 입력은 등록되지않았습니다. 다시 입력해주세요.');
        continue; //1,2 외 입력시 다시 입력
      }
      print('\n===== ${monster.name}의 턴 =====');
      monster.increaseDefense(); //몬스터 방어력 증가
      monster.attackCharacter(character); //캐릭터 때리기

      //공격,방어 후 상태창 출력
      print('\n--- 현재 상태 ---');
      character.showStatus(); //캐릭터 상태창
      monster.showStatus(); //몬스터 상태창
    }

    if (character.health > 0) {
      //캐릭터가 살아있고 몬스터의 체력이 0이하가 된경우
      print("${monster.name}을(를) 물리쳤습니다!");
      monsterCount++; //잡은몬스터 카운팅
      monsters.remove(monster); // 처치한 몬스터 제거
    }
  }
}

//30% 확률로 체력 보너스 부여
void applyHealthBonus(Character character) {
  if (Random().nextDouble() < 0.3) {
    character.health += 10;
    print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
  }
}

void main() {
  Character player = loadCharacterStats();
  applyHealthBonus(player); // 30% 확률로 체력 보너스

  List<Monster> monsterList = loadMonstersStats();

  if (monsterList.isEmpty) {
    print('몬스터가 존재하지않습니다.');
    return;
  }
  Game game = Game(player, monsterList);
  game.startGame();
}
