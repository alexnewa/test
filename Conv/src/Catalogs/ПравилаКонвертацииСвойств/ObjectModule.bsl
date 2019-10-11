
Перем мЗагрузкаДанных Экспорт;
Перем мУстанавливатьИмяИВидИсточникаПриемника Экспорт;

Процедура СгенерироватьУникальныйКод() Экспорт
	
	УстановитьНовыйКод();	
	
КонецПроцедуры

Функция ОпределитьНужноПриведениеКСтрокеСправа()
	
	Если (НЕ (ИмяПриемника = "Код"
		ИЛИ ИмяПриемника = "Номер"))
		ИЛИ ИмяПриемника <> ИмяИсточника
		ИЛИ ТипИсточника <> ТипПриемника Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ИмяПриемника = "Код" Тогда
		
		Возврат	Приемник.Владелец.Тип = Перечисления.ТипыОбъектов.Справочник
			ИЛИ Приемник.Владелец.Тип = Перечисления.ТипыОбъектов.ПланВидовХарактеристик
			ИЛИ Приемник.Владелец.Тип = Перечисления.ТипыОбъектов.ПланВидовРасчета;
		
	ИначеЕсли ИмяПриемника = "Номер" Тогда
		
		Возврат Приемник.Владелец.Тип = Перечисления.ТипыОбъектов.Документ
			ИЛИ Приемник.Владелец.Тип = Перечисления.ТипыОбъектов.БизнесПроцесс
			ИЛИ Приемник.Владелец.Тип = Перечисления.ТипыОбъектов.Задача;
			
	КонецЕсли;			
			
	Возврат Ложь;		
	
КонецФункции

Процедура АвтоматическиУстановитьПриведениеНомераКДлинне()
	
	Если НЕ ЗначениеЗаполнено(Приемник)
		ИЛИ НЕ ЗначениеЗаполнено(Источник)
		ИЛИ Не ПустаяСтрока(АлгоритмПередВыгрузкойСвойства) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// если код для справочника и номер для документа строковые и больший по длине номер переносится в меньший, то
	// номер берется справа, а не слева, как по умолчанию
	Если НЕ мЗагрузкаДанных
		И ОпределитьНужноПриведениеКСтрокеСправа()
		И Найти(ТипИсточника, "Строка") > 0
		И Найти(ТипПриемника, "Строка") > 0
		И Приемник.КвалификаторыСтроки_Длина <> 0
		И Источник.Владелец.Владелец.Приложение <> Перечисления.Приложения.Предприятие77
		И Источник.КвалификаторыСтроки_Длина <> Приемник.КвалификаторыСтроки_Длина Тогда
		
			АвтоматическиПриводитьЗначениеКДлинеПриемника = Истина;			
				
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если мУстанавливатьИмяИВидИсточникаПриемника Тогда
		
		Если ЭтоНовый()
			ИЛИ Источник <> Ссылка.Источник Тогда
		
			ИмяИсточника = Строка(Источник);
			Если Не ПустаяСтрока(ИмяИсточника) Тогда
				
				ВидИсточника = XMLСтрока(Источник.Вид);
				Если Источник.Типы.Количество() = 1 Тогда
					ТипИсточника = Строка(Источник.Типы[0].Тип);
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЭтоНовый()
			ИЛИ Приемник <> Ссылка.Приемник Тогда
		
			ИмяПриемника = Строка(Приемник);
			Если Не ПустаяСтрока(ИмяПриемника) Тогда
				
				ВидПриемника = XMLСтрока(Приемник.Вид);
				Если Приемник.Типы.Количество() = 1 Тогда
					ТипПриемника = Строка(Приемник.Типы[0].Тип);
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПравилоКонвертации) Тогда
		ИмяПравилаКонвертации = "";
	Иначе
		ИмяПравилаКонвертации = СокрЛП(ПравилоКонвертации);
	КонецЕсли;
	
	Если НЕ мЗагрузкаДанных Тогда
		
		Наименование = глНаименованиеПКС(ЭтотОбъект);

    	Если Порядок = 0 Тогда
    		Порядок = ОчереднойПорядок("ПравилаКонвертацииСвойств", Родитель, Владелец);
		КонецЕсли;
		
		Если НЕ ЭтоГруппа Тогда
		
			Если ЭтоНовый() Тогда
				
				АвтоматическиУстановитьПриведениеНомераКДлинне();
				
			КонецЕсли;
			
			Если Поиск Тогда
				
				// поиск возможет только если объект приемник - ссылочного типа
				Если НЕ ЗначениеЗаполнено(ИмяПараметраДляПередачи)
					И НЕ глЕстьСсылка(Владелец.Приемник) Тогда
					
					Поиск = Ложь;
					Сообщить("Поиск по полю отменен, так как объект для загрузки в применике не ссылочного типа.");
					
				КонецЕсли;
				
			Иначе
				
				ПоискПоДатеНаРавенство = Ложь;	
				
			КонецЕсли;
			
		КонецЕсли;
		
    КонецЕсли;    
  	
КонецПроцедуры

Функция НайтиПравилаКО(Владелец, Источник, Приемник, ПрименитьНеЧеткийПоиск = Ложь) Экспорт

	НайденныеПКО  = Новый СписокЗначений;
	
	Если НЕ ПрименитьНеЧеткийПоиск Тогда
		
		Если Источник.Типы.Количество() <> 1
			ИЛИ Приемник.Типы.Количество() <> 1 Тогда
			
			Возврат НайденныеПКО;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТипыИсточника = Новый СписокЗначений;
	ТипыПриемника = Новый СписокЗначений;

	Если НЕ Источник.Пустая() Тогда
		Для каждого Типы из Источник.Типы Цикл
			ТипыИсточника.Добавить(Типы.Тип);
		КонецЦикла;
	КонецЕсли;

	Если НЕ Приемник.Пустая() Тогда
		Для каждого Типы из Приемник.Типы Цикл
			ТипыПриемника.Добавить(Типы.Тип);
		КонецЦикла;
	Иначе
		Возврат НайденныеПКО;
	КонецЕсли;

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Владелец",           Владелец);
	Запрос.УстановитьПараметр("ТипыИсточника",      ТипыИсточника);
	Запрос.УстановитьПараметр("ТипыПриемника",      ТипыПриемника);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПравилаКонвертацииОбъектов.Ссылка КАК ПКО
	|ИЗ
	|	Справочник.ПравилаКонвертацииОбъектов КАК ПравилаКонвертацииОбъектов
	|
	|ГДЕ
	|	ПравилаКонвертацииОбъектов.Владелец = &Владелец И
	|	ПравилаКонвертацииОбъектов.Приемник В(&ТипыПриемника)";

	Если ТипыИсточника.Количество() <> 0 Тогда
		Запрос.Текст = Запрос.Текст + "И ПравилаКонвертацииОбъектов.Источник В(&ТипыИсточника)";
	КонецЕсли;

	РезЗапроса = Запрос.Выполнить();

	РезТаблица = РезЗапроса.Выгрузить();

	Для каждого Строка из РезТаблица Цикл
		
		НайденныеПКО.Добавить(Строка.ПКО);
		
	КонецЦикла;

	Возврат НайденныеПКО;

КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Наименование = глНаименованиеПКС(ЭтотОбъект);
	
КонецПроцедуры

мУстанавливатьИмяИВидИсточникаПриемника = Истина;
мЗагрузкаДанных = Ложь;
