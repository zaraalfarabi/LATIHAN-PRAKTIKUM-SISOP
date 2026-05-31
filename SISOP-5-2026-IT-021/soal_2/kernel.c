int cursor = 0;
char color = 0x07;

void putInMemory(int segment, int address, char character);
int getChar();
void printChar(char c);
void printString(char* str);
void newline();
void clearScreen();
void readString(char* buf);
int strcmp(char* a, char* b);
int startsWith(char* str, char* prefix);
int atoi(char* str);
void intToString(int num, char* str);
int factorial(int n);
char getDigit(int num);
/*
 * Final Challenge
 *
 * Commands:
 * - check
 * - add <a> <b>
 * - sub <a> <b>
 * - fac <n>
 * - season <name>
 * - triangle <n>
 * - clear
 * - about
 *
 * Season list:
 * - winter
 * - spring
 * - summer
 * - fall
 * - radiant
 *
 * Restrictions:
 * - no stdlib
 * - avoid division (/)
 * - avoid modulo (%)
 */

/*
 * TODO:
 * 1. printChar()
 * 2. printString()
 * 3. clearScreen()
 * 4. readString()
 * 5. strcmp()
 * 6. startsWith()
 * 7. atoi()
 * 8. intToString()
 * 9. factorial()
 * 10. add handler
 * 11. sub handler
 * 12. fac handler
 * 13. season handler
 * 14. triangle handler
 * 15. shell loop
 */

void main() {

    char cmd[64];

    clearScreen();

    printString("Welcome to <X>");
    newline();

    printString("type 'help'");
    newline();
    newline();

    while (1) {

        printString("> ");

        readString(cmd);

        newline();

if (strcmp(cmd, "check")) {
    printString("ok");
}
else if (strcmp(cmd, "about")) {
    printString("Final Challenge");
}
else if (strcmp(cmd, "clear")) {
    clearScreen();
}
else if (strcmp(cmd, "season winter")) {
    printString("cold");
}
else if (strcmp(cmd, "season spring")) {
    printString("flowers");
}
else if (strcmp(cmd, "season summer")) {
    printString("hot");
}
else if (strcmp(cmd, "season fall")) {
    printString("leaves");
}
else if (strcmp(cmd, "season radiant")) {
    printString("special");
}
else if (startsWith(cmd, "fac ")) {

    int n;
    int resultNum;
    char result[10];

    n = atoi(cmd + 4);

    resultNum = factorial(n);

    intToString(resultNum, result);

    printString(result);
}
else if (startsWith(cmd, "add ")) {

    int a;
    int b;
    int i;
    char second[10];
    char result[10];

    i = 4;

    while (cmd[i] != ' ') {
        i++;
    }

    cmd[i] = 0;

    a = atoi(cmd + 4);

    i++;

    b = atoi(cmd + i);

    intToString(a + b, result);

    printString(result);
}
else if (startsWith(cmd, "sub ")) {

    int a;
    int b;
    int i;
    char result[10];

    i = 4;

    while (cmd[i] != ' ') {
        i++;
    }

    cmd[i] = 0;

    a = atoi(cmd + 4);

    i++;

    b = atoi(cmd + i);

    intToString(a - b, result);

    printString(result);
}
else if (startsWith(cmd, "triangle ")) {

    int n;
    int row;
    int col;

    n = atoi(cmd + 9);

    for (row = 1; row <= n; row++) {

        for (col = 1; col <= row; col++) {
            printChar('x');
        }

        newline();
    }
}
else if (strcmp(cmd, "help")) {

    printString("check");
    newline();

    printString("add <a> <b>");
    newline();

    printString("sub <a> <b>");
    newline();

    printString("fac <n>");
    newline();

    printString("season <name>");
    newline();

    printString("triangle <n>");
    newline();

    printString("clear");
    newline();

    printString("about");
}
else {
    printString("unknown command");
}

        newline();
    }
}
void printChar(char c) {

    putInMemory(0xB800, cursor * 2, c);
    putInMemory(0xB800, cursor * 2 + 1, color);

    cursor++;
}


void printString(char* str) {

    int i = 0;

    while (str[i] != 0) {
        printChar(str[i]);
        i++;
    }
}

void newline() {

    while (cursor < 2000) {

        if (
            cursor == 80  || cursor == 160 || cursor == 240 ||
            cursor == 320 || cursor == 400 || cursor == 480 ||
            cursor == 560 || cursor == 640 || cursor == 720 ||
            cursor == 800 || cursor == 880 || cursor == 960 ||
            cursor == 1040 || cursor == 1120 || cursor == 1200 ||
            cursor == 1280 || cursor == 1360 || cursor == 1440 ||
            cursor == 1520 || cursor == 1600 || cursor == 1680 ||
            cursor == 1760 || cursor == 1840 || cursor == 1920
        ) {
            return;
        }

        cursor++;
    }
}

void clearScreen() {

    int i;

    for (i = 0; i < 80 * 25; i++) {

        putInMemory(0xB800, i * 2, ' ');
        putInMemory(0xB800, i * 2 + 1, color);
    }

    cursor = 0;
}

void readString(char* buf) {

    int i = 0;
    char c;

    while (1) {

        c = getChar();

        if (c == 13) {
            buf[i] = 0;
            return;
        }

        buf[i] = c;
        printChar(c);

        i++;
    }
}

int strcmp(char* a, char* b) {

    int i = 0;

    while (a[i] != 0 && b[i] != 0) {

        if (a[i] != b[i]) {
            return 0;
        }

        i++;
    }

    return a[i] == 0 && b[i] == 0;
}

int startsWith(char* str, char* prefix) {

    int i = 0;

    while (prefix[i] != 0) {

        if (str[i] != prefix[i]) {
            return 0;
        }

        i++;
    }

    return 1;
}

int atoi(char* str) {

    int result = 0;
    int i = 0;

    while (str[i] != 0) {

        result = result * 10 + (str[i] - '0');
        i++;
    }

    return result;
}
void intToString(int num, char* str) {

    int hundreds = 0;
    int tens = 0;
    int i = 0;

    while (num >= 100) {
        hundreds++;
        num = num - 100;
    }

    while (num >= 10) {
        tens++;
        num = num - 10;
    }

    if (hundreds > 0) {
        str[i++] = getDigit(hundreds);
    }

    if (hundreds > 0 || tens > 0) {
        str[i++] = getDigit(tens);
    }

    str[i++] = getDigit(num);
    str[i] = 0;
}


int factorial(int n) {

    int result = 1;
    int i;

    for (i = 1; i <= n; i++) {
        result = result * i;
    }

    return result;
}
char getDigit(int num) {

    if (num == 0) return '0';
    if (num == 1) return '1';
    if (num == 2) return '2';
    if (num == 3) return '3';
    if (num == 4) return '4';
    if (num == 5) return '5';
    if (num == 6) return '6';
    if (num == 7) return '7';
    if (num == 8) return '8';

    return '9';
}
