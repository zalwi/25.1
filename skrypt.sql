-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.

CREATE TABLE pracownik (
	id BIGINT PRIMARY KEY auto_increment,
	imie VARCHAR(50) NOT NULL,
	nazwisko VARCHAR(50) NOT NULL,
	wyplata DECIMAL(10, 2),
	data_urodzenia DATETIME,
	stanowisko VARCHAR(200) NOT NULL
);
-- Wstawia do tabeli co najmniej 6 pracowników

INSERT 
    INTO pracownik(imie, nazwisko, wyplata, data_urodzenia, stanowisko) 
VALUES 
	('Jan','Kowalski','1800','1975-05-29','Konserwator powierzchni płaskich'),
	('Piotr','Pierwszy','2500','1984-02-15','Logistyk'),
	('Paweł','Drugi','3000','1987-06-12','Analityk'),
	('Maciej','Chrabąszcz','4500','1990-11-01','Informatyk'),
	('Krystyna','Klubówna','3100','1997-08-17','Sekretarka'),
	('Aleksander','Wielki','7400','1989-01-01','Prezes');
	
-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku

SELECT * 
    FROM pracownik
    ORDER BY nazwisko;

-- Pobiera pracowników na wybranym stanowisku

SELECT * 
    FROM pracownik
    WHERE stanowisko='Prezes';

-- Pobiera pracowników, którzy mają co najmniej 30 lat

SELECT * 
    FROM pracownik
    WHERE data_urodzenia <= DATE_SUB(NOW(),INTERVAL 30 YEAR);

-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%

UPDATE pracownik 
    SET wyplata = wyplata * 1.1 
    WHERE stanowisko='Sekretarka';

-- Usuwa najmłodszego pracownika

DELETE FROM pracownik
WHERE data_urodzenia = (
	SELECT MAX(data_urodzenia) 
	FROM (SELECT * FROM pracownik) AS tmp
);

-- Usuwa tabelę pracownik

DROP TABLE pracownik

-- Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)

CREATE TABLE stanowisko (
	id BIGINT PRIMARY KEY auto_increment,
	nazwa VARCHAR(200) NOT NULL,
	opis VARCHAR(500) NOT NULL,
	wyplata DECIMAL(10, 2)
);

-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)

CREATE TABLE adres (
	id BIGINT PRIMARY KEY auto_increment,
	ulica VARCHAR(200) NOT NULL,
	nr_domu VARCHAR(10) NOT NULL,
	nr_mieszkania VARCHAR(10),
	kod_pocztowy VARCHAR(10) NOT NULL,
	miejscowosc  VARCHAR(200) NOT NULL
);

-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres

CREATE TABLE pracownik (
	id BIGINT PRIMARY KEY auto_increment,
	imie VARCHAR(50) NOT NULL,
	nazwisko VARCHAR(50) NOT NULL,
	data_urodzenia DATETIME,
	stanowisko_id BIGINT NOT NULL,
	adres_id BIGINT NOT NULL,
	FOREIGN KEY(stanowisko_id) REFERENCES stanowisko(id),
	FOREIGN KEY(adres_id) REFERENCES adres(id)
);

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)

INSERT 
    INTO stanowisko(nazwa, opis, wyplata) 
VALUES 
	('Informatyk','Wspacie IT, programista','4500'),
	('Sekretarka','Barista','3300'),
	('Prezes','Szef wszystkich szefów','7500');
	
INSERT 
    INTO adres(ulica, nr_domu, nr_mieszkania, kod_pocztowy, miejscowosc) 
VALUES 
	('Korzenna','3','6', '90210', 'Nibylądek'),
	('Stokrotki','12a',null, '90210', 'Nibylądek'),
	('Nibyszewo','45',null, '91213', 'Nibyszewo');
	
INSERT 
    INTO pracownik(imie, nazwisko, data_urodzenia, stanowisko_id, adres_id) 
VALUES 
	('Maciej','Chrabąszcz','1990-11-01',1,1),
	('Krystyna','Klubówna','1997-08-17',2,2),
	('Aleksander','Wielki','1989-01-01',3,3);
	   
-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)

SELECT p.imie, p.nazwisko, a.ulica, a.nr_domu, a.nr_mieszkania, a.kod_pocztowy, a.miejscowosc, s.nazwa, s.opis, s.wyplata
FROM pracownik p
INNER JOIN adres a ON p.adres_id = a.id
INNER JOIN stanowisko s ON p.stanowisko_id = s.id;

-- Oblicza sumę wypłat dla wszystkich pracowników w firmie

SELECT SUM(s.wyplata) AS suma_wyplat
FROM pracownik p
INNER JOIN stanowisko s ON p.stanowisko_id = s.id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)

SELECT p.imie, p.nazwisko, a.ulica, a.nr_domu, a.nr_mieszkania, a.kod_pocztowy, a.miejscowosc
FROM pracownik p
INNER JOIN adres a ON p.adres_id = a.id
WHERE a.kod_pocztowy = '90210'
-- koniec skryptu