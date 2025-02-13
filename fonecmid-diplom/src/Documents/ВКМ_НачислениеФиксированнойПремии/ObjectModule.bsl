#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ДополнительныеНачисления.Записывать = Истина;
	Движения.Удержания.Записывать = Истина;
	Для Каждого ТекСтрокаНачисления Из Начисления Цикл
		Движение = Движения.ДополнительныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисления.Премия;
		Движение.Сотрудник = ТекСтрокаНачисления.Сотрудник;
		Движение.ПериодРегистрации = Дата;
		Движение.Сумма = ТекСтрокаНачисления.СуммаПремии;
		
		ДвижениеУдержания = Движения.Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеУдержания, Движение);
		ДвижениеУдержания.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.ВКМ_НДФЛ;
		ДвижениеУдержания.Сумма = Окр(Движение.Сумма * 0,13, 2);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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