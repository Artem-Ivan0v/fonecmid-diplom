#Если Сервер Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция УсловияОплатыПоСотруднику(Сотрудник, Дата = Неопределено) Экспорт
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	*
	               |ИЗ
	               |	РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(&Дата, Сотрудник = &Сотрудник) КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Выборка.Следующий();
		Возврат ВКМ_ПолезныеФункции.СтрокаВыборкиВСтруктуру(Выборка);
	КонецЕсли;	

КонецФункции

#КонецОбласти

#КонецЕсли