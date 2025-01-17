﻿#language: ru

Функционал: Массовое создание актов

Как Бухгалтер
Я хочу массово создать акты 
Чтобы получить оплату по выполненным работам 

Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: Массовое создание актов

	И В командном интерфейсе я выбираю 'Добавленные объекты' 'Массовое создание актов'
	Тогда открылось окно 'Массовое создание актов'
	И я нажимаю кнопку выбора у поля с именем "Период"
	Тогда открылось окно 'Выберите период'
	И я нажимаю кнопку выбора у поля с именем "DateBegin"
	И в поле с именем 'DateBegin' я ввожу текст '01.10.2023'
	И я нажимаю кнопку выбора у поля с именем "DateEnd"
	И в поле с именем 'DateEnd' я ввожу текст '31.10.2023'
	И я нажимаю на кнопку 'Выбрать'
	Тогда открылось окно 'Массовое создание актов *'
	И я нажимаю на кнопку 'Заполнить договоры'
	Тогда открылось окно 'Массовое создание актов'
	И я нажимаю на кнопку 'Сформировать реализации'

