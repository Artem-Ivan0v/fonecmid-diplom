
Функция PingPing(Запрос)
	
	Возврат ВКМ_ОбщегоНазначенияHTTP.ПростойУспешныйОтвет();
	
КонецФункции

Функция SendPostSend(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачалоЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	Попытка
		Ответ = ВКМ_Телеграм.ОбработатьВходящийЗапрос(Запрос);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Ответ = ВКМ_ОбщегоНазначенияHTTP.ОтветОбОшибке(ИнформацияОбОшибке);
	КонецПопытки;
	
	ОценкаПроизводительности.ЗакончитьЗамерВремениТехнологический("Bots.send", НачалоЗамера);
	
	ВКМ_ОбщегоНазначенияHTTP.ЗаписьЛога("send", Запрос, Ответ);
	
	Возврат Ответ;
	
КонецФункции
