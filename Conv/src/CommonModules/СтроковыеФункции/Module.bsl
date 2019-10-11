
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ СО СТРОКАМИ

// Функция "расщепляет" строку на подстроки, используя заданный
//      разделитель. Разделитель может иметь любую длину.
//      Если в качестве разделителя задан пробел, рядом стоящие пробелы
//      считаются одним разделителем, а ведущие и хвостовые пробелы параметра Стр
//      игнорируются.
//      Например,
//      РазложитьСтрокуВМассивПодстрок(",один,,,два", ",") возвратит массив значений из пяти элементов,
//      три из которых - пустые строки, а
//      РазложитьСтрокуВМассивПодстрок(" один   два", " ") возвратит массив значений из двух элементов
//
//  Параметры:
//      Стр -           строка, которую необходимо разложить на подстроки.
//                      Параметр передается по значению.
//      Разделитель -   строка-разделитель, по умолчанию - запятая.
//
//  Возвращаемое значение:
//      массив значений, элементы которого - подстроки
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр, Поз - 1));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз - 1));
			Стр = Сред(Стр, Поз + ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

// Сравнить две строки версий.
//
// Параметры
//  СтрокаВерсии1  – Строка – номер версии в формате РР.{П|ПП}.ЗЗ.СС
//  СтрокаВерсии2  – Строка – второй сравниваемый номер версии
//
// Возвращаемое значение:
//   Число   – больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0.0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0.0.0", СтрокаВерсии2);
	Версия1 = РазложитьСтрокуВМассивПодстрок(Строка1, ".");
	Если Версия1.Количество() <> 4 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
		                    НСтр("ru = 'Неправильный формат строки версии: %1'"), СтрокаВерсии1);
	КонецЕсли;
	Версия2 = РазложитьСтрокуВМассивПодстрок(Строка2, ".");
	Если Версия2.Количество() <> 4 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
	                         НСтр("ru = 'Неправильный формат строки версии: %1'"), СтрокаВерсии2);
	КонецЕсли;
	
	Результат = 0;
	Для Разряд = 0 По 3 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 10.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра").
// Параметр<n>         - Строка - параметр
// Возвращаемое значение:
//   Строка   – текстовая строка с подставленными параметрами
//
// Пример:
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк");
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
                                   Знач Параметр1,
                                   Знач Параметр2 = Неопределено,
                                   Знач Параметр3 = Неопределено,
                                   Знач Параметр4 = Неопределено,
                                   Знач Параметр5 = Неопределено,
                                   Знач Параметр6 = Неопределено,
                                   Знач Параметр7 = Неопределено,
                                   Знач Параметр8 = Неопределено,
                                   Знач Параметр9 = Неопределено,
                                   Знач Параметр10 = Неопределено) Экспорт
	
	СтрокаРезультата = СтрокаПодстановки;
	
	СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%1", Параметр1);
	
	Если Параметр2 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%2", Параметр2);
	КонецЕсли;
	
	Если Параметр3 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%3", Параметр3);
	КонецЕсли;
	
	Если Параметр4 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%4", Параметр4);
	КонецЕсли;
	
	Если Параметр5 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%5", Параметр5);
	КонецЕсли;
	
	Если Параметр6 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%6", Параметр6);
	КонецЕсли;
	
	Если Параметр7 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%7", Параметр7);
	КонецЕсли;
	
	Если Параметр8 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%8", Параметр8);
	КонецЕсли;
	
	Если Параметр9 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%9", Параметр9);
	КонецЕсли;
	
	Если Параметр10 <> Неопределено Тогда
		СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%10", Параметр10);
	КонецЕсли;
	
	Возврат СтрокаРезультата;
	
КонецФункции

// Подставляет параметры в строку. Неограниченное число параметров в строке.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%1").
//  МассивПараметров   - Массив - массив строк, которые соответствуют параметрам в строке подстановки
//
// Возвращаемое значение:
//   Строка   – текстовая строка с подставленными параметрами
//
// Пример:
// МассивПараметров = Новый Массив;
// МассивПараметров = МассивПараметров.Добавить("Вася");
// МассивПараметров = МассивПараметров.Добавить("Зоопарк");
//
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), МассивПараметров);
//
Функция ПодставитьПараметрыВСтрокуИзМассива(Знач СтрокаПодстановки, МассивПараметров) Экспорт
	
	СтрокаРезультата = СтрокаПодстановки;
	
	Для Индекс = 1 По МассивПараметров.Количество() Цикл
		Если Не ПустаяСтрока(МассивПараметров[Индекс-1]) Тогда
			СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%"+Строка(Индекс), МассивПараметров[Индекс-1]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаРезультата;
	
КонецФункции

