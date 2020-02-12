---
layout: post
title:  "Welcome to Jekyll!"
# date:   2019-11-17 23:48:01 +0800
category: jekyll-update
tags: post1
---
```cpp
#include <cstdio>
#include <deque>
#include <windows.h>
using namespace std;
COORD gSize{32, 16}, pos{1, 0}, food = gSize;
deque<COORD> snake(1, {0, 0});
int cdprintf(COORD cd, const char *s)
{
	return SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cd), printf(s);
}
int isLegal(COORD cd)
{
	for (deque<COORD>::iterator it = snake.begin(); it != snake.end(); ++it)
		if (it->X == cd.X && it->Y == cd.Y)
			return 0;
	return 0 <= cd.X && cd.X < gSize.X && 0 <= cd.Y && cd.Y < gSize.Y;
}
int main()
{
	for (int i = 0; i < gSize.Y; ++i)
		cdprintf({gSize.X, i}, "♂");
	cdprintf({0, gSize.Y}, "←↑↓→方向键移动，Space键暂停");
	for (int SCORE = 0, FOOD = 0, BACK = 0; isLegal({snake.front().X + pos.X, snake.front().Y + pos.Y}); Sleep(255))
	{
		if (BACK)
			--BACK;
		else
			cdprintf(snake.back(), " "), snake.pop_back();
		snake.push_front({snake.front().X + pos.X, snake.front().Y + pos.Y});
		cdprintf(snake.front(), "*");
		if (!isLegal(food))
		{
			char s[63];
			sprintf(s, "WuK的贪吃蛇 %d分", SCORE += FOOD), SetConsoleTitle(s);
			for (BACK += FOOD; !isLegal(food = {rand() % gSize.X, rand() % gSize.Y});)
				;
			sprintf(s, "%d", FOOD = rand() % 3 + 1), cdprintf(food, s);
		}
		if (GetAsyncKeyState(VK_SPACE))
			MessageBox(NULL, "游戏很好玩？\n请联系wu.kan@foxmail.com", "By WuK", NULL);
		else if (GetAsyncKeyState(VK_UP) && pos.Y != 1)
			pos = {0, -1};
		else if (GetAsyncKeyState(VK_DOWN) && pos.Y != -1)
			pos = {0, 1};
		else if (GetAsyncKeyState(VK_LEFT) && pos.X != 1)
			pos = {-1, 0};
		else if (GetAsyncKeyState(VK_RIGHT) && pos.X != -1)
			pos = {1, 0};
	}
	MessageBox(NULL, "Game Over", "By WuK", NULL);
}
```