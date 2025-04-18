﻿#Область ПрограммныйИнтерфейс

Процедура ОтразитьДвиженияТоварыНаСкладах(ПараметрыПроведения, Отказ = Ложь) Экспорт
	
	Движения = ПараметрыПроведения.Движения.ТоварыНаСкладах;
	Движения.Записывать = Истина;
	ЭтоРасход = (ПараметрыПроведения.ВидДвижения = ВидДвиженияНакопления.Расход);
	
	Если ЭтоРасход Тогда
		Движения.Записать();
	КонецЕсли;
	
	Для Каждого СтрокаТовары Из ПараметрыПроведения.ТаблицаТоваров Цикл
		
		Движение = Движения.Добавить();
		Движение.ВидДвижения = ПараметрыПроведения.ВидДвижения;
		Движение.Период = ПараметрыПроведения.Период;
		Движение.Номенклатура = СтрокаТовары.Номенклатура;
		Движение.Склад = ПараметрыПроведения.Склад;
		Движение.Количество = СтрокаТовары.Количество;
		Движение.Сумма = ?(ЭтоРасход, СтрокаТовары.Себестоимость, СтрокаТовары.Сумма);
		
		Если ПараметрыПроведения.НастройкаПартионногоУчета <> Перечисления.ТипПартионногоУчета.ПоСредней Тогда
			Движение.Партия = ?(ЭтоРасход , СтрокаТовары.Партия, ПараметрыПроведения.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтразитьДвиженияПродажи(ПараметрыПроведения) Экспорт
	
	Движения = ПараметрыПроведения.Движения.Продажи;
	Движения.Записывать = Истина;

	Для Каждого СтрокаТовары Из ПараметрыПроведения.ТаблицаТоваров Цикл
		Движение = Движения.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, ПараметрыПроведения);
		ЗаполнитьЗначенияСвойств(Движение, СтрокаТовары);
		//Движение.Период = ПараметрыПроведения.Период;
		//Движение.Номенклатура = СтрокаТовары.Номенклатура;
		//Движение.Партия = СтрокаТовары.Партия;
		//Движение.Склад = ПараметрыПроведения.Склад;
		//Движение.Количество = СтрокаТовары.Количество;
		//Движение.Сумма = СтрокаТовары.СуммаПродажи;
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьПараметрыПроведения(Объект, Отказ = Ложь) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	НастройкаПартионногоУчета = Константы.НастройкаПартионногоУчета.Получить();
	
	Если НастройкаПартионногоУчета = Неопределено Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон("Не заполнена настрока партионного учета");
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат ПараметрыПроведения;
		
	КонецЕсли;
	
	ПараметрыПроведения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыПроведения.Вставить("Склад", Объект.Склад);
	ПараметрыПроведения.Вставить("Движения", Объект.Движения);
	ПараметрыПроведения.Вставить("Период", Объект.Дата);
	ПараметрыПроведения.Вставить("НастройкаПартионногоУчета", НастройкаПартионногоУчета);
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.РеализацияТоваров") Тогда
		ПараметрыПроведения.Вставить("ТаблицаТоваров", ВыполнитьКонтрольОстатковИПолучитьТаблицуТоваров(Объект, НастройкаПартионногоУчета, Отказ));
		ПараметрыПроведения.Вставить("ВидДвижения", ВидДвиженияНакопления.Расход);
		
	Иначе
		ПараметрыПроведения.Вставить("ТаблицаТоваров", Объект.Товары);
		ПараметрыПроведения.Вставить("ВидДвижения", ВидДвиженияНакопления.Приход);
	КонецЕсли;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыполнитьКонтрольОстатковИПолучитьТаблицуТоваров(Объект, НастройкаПартионногоУчета, Отказ)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = ПолучитьТекстЗапросаДляФормированияТаблицыПартий();
	
	Если НастройкаПартионногоУчета <> Перечисления.ТипПартионногоУчета.LIFO Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "УБЫВ", "ВОЗР");
	КонецЕсли;
	
	ТаблицаТовары = Объект.Товары.Выгрузить();
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("МоментВремени", Объект.МоментВремени());
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТовары);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ТаблицаТовары.Очистить();
	ТаблицаТовары.Колонки.Добавить("Партия", Новый ОписаниеТипов("ДокументСсылка.ПоступлениеТоваров"));
	ТаблицаТовары.Колонки.Добавить("Себестоимость", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15,2)));
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество > Выборка.КоличествоОстаток Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("На складе %1, по номенклатуре %2 не хватает %3 единиц товара",
										Объект.Склад, Выборка.Номенклатура, 
										Выборка.Количество - Выборка.КоличествоОстаток);
			Сообщение.Сообщить();
		КонецЕсли;
		
		Количество = Выборка.Количество;
		ВыборкаДетально = Выборка.Выбрать();
		
		Пока ВыборкаДетально.Следующий() Цикл
			
			СтрокаТовары = ТаблицаТовары.Добавить();
			
			ЗаполнитьЗначенияСвойств(СтрокаТовары, ВыборкаДетально, "Номенклатура, Партия, Сумма");
			
			Если Количество <= ВыборкаДетально.КоличествоОстаток Тогда
				СтрокаТовары.Количество = Количество;
				СтрокаТовары.Себестоимость = ВыборкаДетально.СуммаОстаток / ВыборкаДетально.КоличествоОстаток * Количество;
				Прервать;
			Иначе
				Количество = Количество - ВыборкаДетально.КоличествоОстаток;
				СтрокаТовары.Количество = ВыборкаДетально.КоличествоОстаток;
				СтрокаТовары.Себестоимость = ВыборкаДетально.СуммаОстаток
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТаблицаТовары;
	
КонецФункции

Функция ПолучитьТекстЗапросаДляФормированияТаблицыПартий()
	
	ТекстЗапроса =  
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ТаблицаТовары.Количество КАК Количество,
		|	ТаблицаТовары.Сумма КАК Сумма
		|ПОМЕСТИТЬ ВТ_ТаблицаТоваров
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
		|	ТоварыНаСкладахОстатки.Склад КАК Склад,
		|	ТоварыНаСкладахОстатки.Партия КАК Партия,
		|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	ТоварыНаСкладахОстатки.СуммаОстаток КАК СуммаОстаток,
		|	ТоварыНаСкладахОстатки.Партия.МоментВремени КАК МоментВремени
		|ПОМЕСТИТЬ ВТ_ТаблицаОстатков
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(
		|			&МоментВремени,
		|			(Номенклатура, Склад) В
		|				(ВЫБРАТЬ
		|					ВТ_ТаблицаТоваров.Номенклатура,
		|					&Склад
		|				ИЗ
		|					ВТ_ТаблицаТоваров)) КАК ТоварыНаСкладахОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Склад,
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаТоваров.Номенклатура КАК Номенклатура,
		|	ВТ_ТаблицаТоваров.Количество КАК Количество,
		|	ВТ_ТаблицаОстатков.Партия КАК Партия,
		|	ВТ_ТаблицаОстатков.КоличествоОстаток КАК КоличествоОстаток,
		|	ВТ_ТаблицаОстатков.СуммаОстаток КАК СуммаОстаток,
		|	ВТ_ТаблицаТоваров.Сумма КАК Сумма
		|ИЗ
		|	ВТ_ТаблицаТоваров КАК ВТ_ТаблицаТоваров
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТаблицаОстатков КАК ВТ_ТаблицаОстатков
		|		ПО ВТ_ТаблицаТоваров.Номенклатура = ВТ_ТаблицаОстатков.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_ТаблицаОстатков.Партия.МоментВремени УБЫВ
		|ИТОГИ
		|	МАКСИМУМ(Количество),
		|	СУММА(КоличествоОстаток),
		|	СУММА(СуммаОстаток),
		|	МАКСИМУМ(Сумма)
		|ПО
		|	Номенклатура";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
