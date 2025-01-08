
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
	// Акт оказанных услуг
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОказанныхУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт оказанных услуг'");
	КомандаПечати.Порядок = 10;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
			
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОказанныхУслуг");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАктаОказанныхУслуг(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт оказанных услуг'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОказанныхУслуг";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьАктаОказанныхУслуг(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "АктОказанныхУслуг";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОказанныхУслуг");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиЗаголовок(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиОсновнуюЧастьТоварнойНакладной(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(ДанныеДокументов.Ссылка, 1, 120);
		Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
			ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
			            |Технические подробности см. в журнале регистрации.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Иначе
			КартинкаQRКода = Новый Картинка(ДанныеQRКода);
			Макет.Рисунки.QRКод.Картинка = КартинкаQRКода;
		КонецЕсли;
		
		ВывестиПодвал(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Номер КАК Номер,
	               |	РеализацияТоваровУслуг.Дата КАК Дата,
	               |	РеализацияТоваровУслуг.Организация КАК Организация,
	               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	               |	РеализацияТоваровУслуг.Договор КАК Договор,
	               |	РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
	               |	РеализацияТоваровУслуг.Услуги.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги,
	               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ВывестиЗаголовок(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("ЗаголовокДокумента");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("НомерДокумента", ДанныеДокументов.Номер);
	ДанныеПечати.Вставить("ДатаДокумента", ДанныеДокументов.Дата);
	
	ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(ДанныеДокументов.Ссылка, 1, 120);
	Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
		            |Технические подробности см. в журнале регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Иначе
		КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		ОбластьЗаголовокДокумента.Рисунки.QRКод.Картинка = КартинкаQRКода;
	КонецЕсли;
	
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.Контрагент);
	ДанныеПечати.Вставить("Договор", ДанныеДокументов.Договор);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	
КонецПроцедуры

Процедура ВывестиОсновнуюЧастьТоварнойНакладной(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
	Пока ВыборкаУслуги.Следующий() Цикл
		ОбластьСтрокаТаблицы.Параметры.Заполнить(ВыборкаУслуги);
		ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиПодвал(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("СуммаЦифрами", ДанныеДокументов.СуммаДокумента);
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета= "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	СуммаПрописью = ЧислоПрописью(ДанныеПечати.СуммаЦифрами, ФормСтрока, ПарПредмета);
	ДанныеПечати.Вставить("СуммаПрописью", СуммаПрописью);
	
	ОбластьПодвал.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
КонецПроцедуры

Функция РеализацияВПериоде(Договор, Период) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Проведен = ИСТИНА
	               |	И РеализацияТоваровУслуг.Договор = &Договор
	               |	И РеализацияТоваровУслуг.Дата >= &НачалоПериода
	               |	И РеализацияТоваровУслуг.Дата <= &КонецПериода
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	РеализацияТоваровУслуг.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Период.ДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Период.ДатаОкончания));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли