#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвижения();
	
	Движения.ОсновныеНачисления.Записать();
	Движения.ДополнительныеНачисления.Записать();
	
	РасчитатьОклад();
	
	РассчитатьОтпуск();
	
	СформироватьВзаиморасчеты();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвижения()
	
	Если Начисления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МинимальнаяДатаНачала = Неопределено;
	МаксимальнаяДатаОкончания = Неопределено;
	
	Для Каждого Строка Из Начисления Цикл
		
		Если Строка.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисления.Оклад Тогда
			Если Не ЗначениеЗаполнено(МинимальнаяДатаНачала)
				Или МинимальнаяДатаНачала > Строка.ДатаНачала Тогда
				МинимальнаяДатаНачала = Строка.ДатаНачала;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(МаксимальнаяДатаОкончания)
				Или МаксимальнаяДатаОкончания < Строка.ДатаОкончания Тогда
				МаксимальнаяДатаОкончания = Строка.ДатаОкончания;
			КонецЕсли;		
		КонецЕсли;    
		
	КонецЦикла;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НачислениеЗарплатыНачисления.Сотрудник КАК Сотрудник,
	               |	НачислениеЗарплатыНачисления.Подразделение КАК Подразделение,
	               |	НачислениеЗарплатыНачисления.ВидРасчета КАК ВидРасчета,
	               |	НачислениеЗарплатыНачисления.ДатаНачала КАК ДатаНачала,
	               |	НачислениеЗарплатыНачисления.ДатаОкончания КАК ДатаОкончания,
	               |	НачислениеЗарплатыНачисления.ГрафикРаботы КАК ГрафикРаботы
	               |ПОМЕСТИТЬ ВТ_ДанныеДокумента
	               |ИЗ
	               |	Документ.ВКМ_НачислениеЗарплаты.Начисления КАК НачислениеЗарплатыНачисления
	               |ГДЕ
	               |	НачислениеЗарплатыНачисления.Ссылка = &Ссылка
	               |	И НачислениеЗарплатыНачисления.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СведенияОСотрудникахСрезПоследних.Период КАК Период,
	               |	СведенияОСотрудникахСрезПоследних.Сотрудник КАК Сотрудник,
	               |	СведенияОСотрудникахСрезПоследних.Подразделение КАК Подразделение,
	               |	СведенияОСотрудникахСрезПоследних.Оклад КАК Оклад
	               |ПОМЕСТИТЬ ВТ_ИсторияОклада
	               |ИЗ
	               |	РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(
	               |			&МинимальнаяДатаНачала,
	               |			(Сотрудник, Подразделение) В
	               |				(ВЫБРАТЬ
	               |					ВТ_ДанныеДокумента.Сотрудник КАК Сотрудник,
	               |					ВТ_ДанныеДокумента.Подразделение КАК Подразделение
	               |				ИЗ
	               |					ВТ_ДанныеДокумента КАК ВТ_ДанныеДокумента)) КАК СведенияОСотрудникахСрезПоследних
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	СведенияОСотрудниках.Период,
	               |	СведенияОСотрудниках.Сотрудник,
	               |	СведенияОСотрудниках.Подразделение,
	               |	СведенияОСотрудниках.Оклад
	               |ИЗ
	               |	РегистрСведений.ВКМ_УсловияОплатыСотрудников КАК СведенияОСотрудниках
	               |ГДЕ
	               |	СведенияОСотрудниках.Период > &МинимальнаяДатаНачала
	               |	И СведенияОСотрудниках.Период < &МаксимальнаяДатаОкончания
	               |	И (СведенияОСотрудниках.Сотрудник, СведенияОСотрудниках.Подразделение) В
	               |			(ВЫБРАТЬ
	               |				ВТ_ДанныеДокумента.Сотрудник КАК Сотрудник,
	               |				ВТ_ДанныеДокумента.Подразделение КАК Подразделение
	               |			ИЗ
	               |				ВТ_ДанныеДокумента КАК ВТ_ДанныеДокумента)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТекущаяЗапись.Период КАК ДатаНачала,
	               |	ТекущаяЗапись.Сотрудник КАК Сотрудник,
	               |	ТекущаяЗапись.Подразделение КАК Подразделение,
	               |	ЕСТЬNULL(МИНИМУМ(СледующаяЗапись.Период), ДАТАВРЕМЯ(3999, 12, 21)) КАК ДатаОкончания
	               |ПОМЕСТИТЬ ВТ_Интервалы
	               |ИЗ
	               |	ВТ_ИсторияОклада КАК ТекущаяЗапись
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИсторияОклада КАК СледующаяЗапись
	               |		ПО ТекущаяЗапись.Сотрудник = СледующаяЗапись.Сотрудник
	               |			И ТекущаяЗапись.Подразделение = СледующаяЗапись.Подразделение
	               |			И ТекущаяЗапись.Период < СледующаяЗапись.Период
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТекущаяЗапись.Сотрудник,
	               |	ТекущаяЗапись.Подразделение,
	               |	ТекущаяЗапись.Период
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Интервалы.Сотрудник КАК Сотрудник,
	               |	ВТ_Интервалы.Подразделение КАК Подразделение,
	               |	ВТ_ИсторияОклада.Оклад КАК Оклад,
	               |	ВТ_Интервалы.ДатаНачала КАК ДатаНачала,
	               |	ВТ_Интервалы.ДатаОкончания КАК ДатаОкончания
	               |ПОМЕСТИТЬ ВТ_ИнтервалыОклада
	               |ИЗ
	               |	ВТ_Интервалы КАК ВТ_Интервалы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИсторияОклада КАК ВТ_ИсторияОклада
	               |		ПО ВТ_Интервалы.Сотрудник = ВТ_ИсторияОклада.Сотрудник
	               |			И ВТ_Интервалы.Подразделение = ВТ_ИсторияОклада.Подразделение
	               |			И ВТ_Интервалы.ДатаНачала = ВТ_ИсторияОклада.Период
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ДанныеДокумента.Сотрудник КАК Сотрудник,
	               |	ВТ_ДанныеДокумента.Подразделение КАК Подразделение,
	               |	ВТ_ДанныеДокумента.ВидРасчета КАК ВидРасчета,
	               |	ВЫБОР
	               |		КОГДА ВТ_ДанныеДокумента.ДатаНачала < ВТ_ИнтервалыОклада.ДатаНачала
	               |			ТОГДА ВТ_ИнтервалыОклада.ДатаНачала
	               |		ИНАЧЕ ВТ_ДанныеДокумента.ДатаНачала
	               |	КОНЕЦ КАК ПериодДействияНачало,
	               |	ВЫБОР
	               |		КОГДА ВТ_ДанныеДокумента.ДатаОкончания > ВТ_ИнтервалыОклада.ДатаОкончания
	               |			ТОГДА ВТ_ИнтервалыОклада.ДатаОкончания
	               |		ИНАЧЕ ВТ_ДанныеДокумента.ДатаОкончания
	               |	КОНЕЦ КАК ПериодДействияКонец,
	               |	ВТ_ДанныеДокумента.ГрафикРаботы КАК ГрафикРаботы,
	               |	ВТ_ИнтервалыОклада.Оклад КАК Показатель
	               |ИЗ
	               |	ВТ_ДанныеДокумента КАК ВТ_ДанныеДокумента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИнтервалыОклада КАК ВТ_ИнтервалыОклада
	               |		ПО ВТ_ДанныеДокумента.Сотрудник = ВТ_ИнтервалыОклада.Сотрудник
	               |			И ВТ_ДанныеДокумента.Подразделение = ВТ_ИнтервалыОклада.Подразделение
	               |			И ВТ_ДанныеДокумента.ДатаНачала <= ВТ_ИнтервалыОклада.ДатаОкончания
	               |			И ВТ_ДанныеДокумента.ДатаОкончания >= ВТ_ИнтервалыОклада.ДатаНачала
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	НачислениеЗарплатыНачисления.Сотрудник,
	               |	НачислениеЗарплатыНачисления.Подразделение,
	               |	НачислениеЗарплатыНачисления.ВидРасчета,
	               |	НачислениеЗарплатыНачисления.ДатаНачала,
	               |	НачислениеЗарплатыНачисления.ДатаОкончания,
	               |	НачислениеЗарплатыНачисления.ГрафикРаботы,
	               |	NULL
	               |ИЗ
	               |	Документ.ВКМ_НачислениеЗарплаты.Начисления КАК НачислениеЗарплатыНачисления
	               |ГДЕ
	               |	НачислениеЗарплатыНачисления.Ссылка = &Ссылка
	               |	И НачислениеЗарплатыНачисления.ВидРасчета ССЫЛКА ПланВидовРасчета.ОсновныеНачисления
	               |	И НачислениеЗарплатыНачисления.ВидРасчета <> ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МинимальнаяДатаНачала", МинимальнаяДатаНачала);
	Запрос.УстановитьПараметр("МаксимальнаяДатаОкончания", МаксимальнаяДатаОкончания);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ОсновныеНачисления.Добавить();
		Движение.ПериодРегистрации = Дата;
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		
		Если Движение.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисления.Отпуск Тогда
			Движение.БазовыйПериодНачало = НачалоМесяца(ДобавитьМесяц(Движение.ПериодДействияНачало, -12));
			Движение.БазовыйПериодКонец = КонецМесяца(ДобавитьМесяц(Движение.БазовыйПериодНачало, 1));
			Движение.ГрафикРаботы = Справочники.ВКМ_ГрафикиРаботы.Пятидневка;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РасчитатьОклад()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
	               |	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ЗначениеПериодДействия, 0) КАК План,
	               |	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК Факт
	               |ИЗ
	               |	РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(
	               |			ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад)
	               |				И Регистратор = &Ссылка) КАК ОсновныеНачисленияДанныеГрафика";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ОсновныеНачисления[Выборка.НомерСтроки - 1];
		Если Выборка.План = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю("Не заполнен план графика сотрудника");
			Возврат;
		Иначе
			Движение.Сумма = Движение.Показатель * Выборка.Факт / Выборка.План;
		КонецЕсли;
		
		Движение.ЧасовОтработано = Выборка.Факт;
		
		ДвижениеУдержания = Движения.Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеУдержания, Движение);
		ДвижениеУдержания.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.ВКМ_НДФЛ;
		ДвижениеУдержания.Сумма = Окр(Движение.Сумма * 0.13, 2);
		
	КонецЦикла;
	
	Движения.ОсновныеНачисления.Записать(, Истина);
	Движения.Удержания.Записать();
	
КонецПроцедуры

Процедура РассчитатьОтпуск()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
	               |	ЕСТЬNULL(ОсновныеНачисленияБазаДополнительныеНачисления.СуммаБаза, 0) + ЕСТЬNULL(ОсновныеНачисленияБазаОсновныеНачисления.СуммаБаза, 0) КАК СуммаБаза,
	               |	ЕСТЬNULL(ОсновныеНачисленияБазаОсновныеНачисления.ЧасовОтработаноБаза, 0) КАК ЧасовОтработаноБаза,
	               |	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК Факт
	               |ИЗ
	               |	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаДополнительныеНачисления(
	               |				&Измерения,
	               |				&Измерения,
	               |				,
	               |				ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Отпуск)
	               |					И Регистратор = &Ссылка) КАК ОсновныеНачисленияБазаДополнительныеНачисления
	               |		ПО ОсновныеНачисления.НомерСтроки = ОсновныеНачисленияБазаДополнительныеНачисления.НомерСтроки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаОсновныеНачисления(
	               |				&Измерения,
	               |				&Измерения,
	               |				,
	               |				ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Отпуск)
	               |					И Регистратор = &Ссылка) КАК ОсновныеНачисленияБазаОсновныеНачисления
	               |		ПО ОсновныеНачисления.НомерСтроки = ОсновныеНачисленияБазаОсновныеНачисления.НомерСтроки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(
	               |				ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Отпуск)
	               |					И Регистратор = &Ссылка) КАК ОсновныеНачисленияДанныеГрафика
	               |		ПО ОсновныеНачисления.НомерСтроки = ОсновныеНачисленияДанныеГрафика.НомерСтроки
	               |ГДЕ
	               |	ОсновныеНачисления.Регистратор = &Ссылка
	               |	И ОсновныеНачисления.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Отпуск)";
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	Измерения.Добавить("Подразделение");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Измерения", Измерения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ОсновныеНачисления[Выборка.НомерСтроки - 1];
		
		Если Выборка.ЧасовОтработаноБаза = 0 Тогда
			Движение.Сумма = 0;
		Иначе
			Движение.Сумма = Выборка.СуммаБаза * Выборка.Факт / Выборка.ЧасовОтработаноБаза;
		КонецЕсли;
		
		ДвижениеУдержания = Движения.Удержания.Добавить();
		//НужныйВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НайтиПоНаименованию("Тест");
		ЗаполнитьЗначенияСвойств(ДвижениеУдержания, Движение);
		ДвижениеУдержания.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.ВКМ_НДФЛ;
		ДвижениеУдержания.Сумма = Окр(Движение.Сумма * 0,13, 2);
		
	КонецЦикла;
	
	Движения.ОсновныеНачисления.Записать(, Истина);
	Движения.Удержания.Записать();
	
КонецПроцедуры 

Процедура СформироватьВзаиморасчеты()
	
	Для Каждого Строка Из Начисления Цикл
		СуммаВзаиморасчетов = РегистрыНакопления.ВКМ_ВзаиморасчетыССотрудниками.СформироватьВзаиморасчеты(Ссылка);
		Если СуммаВзаиморасчетов > 0 Тогда
			Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Регистратор = Ссылка;
			Движение.Сотрудник = Строка.Сотрудник;
			Движение.Сумма = СуммаВзаиморасчетов;
		КонецЕсли;
	КонецЦикла;
	
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли