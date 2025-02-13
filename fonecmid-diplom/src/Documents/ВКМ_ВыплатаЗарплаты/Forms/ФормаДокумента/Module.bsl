#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Дата) Тогда
		ДатаЗаполнения = ТекущаяДатаСеанса();
	Иначе
		ДатаЗаполнения = Объект.Дата;
	КонецЕсли;
	
	ДанныеЗаполнения = РегистрыНакопления.ВКМ_ВзаиморасчетыССотрудниками.ПолучитьВзаиморасчеты(ДатаЗаполнения);
	
	Объект.Выплаты.Очистить();
	Для Каждого ЭлементМассива Из ДанныеЗаполнения Цикл
		НоваяСтрока = Объект.Выплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти