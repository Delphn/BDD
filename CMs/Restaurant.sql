CREATE TABLE Categorie(
    id_categorie integer,
    nom varchar(25),
    primary key(id_categorie)
);

CREATE TABLE Plat(
    id_plat integer,
    nom varchar(25),
    supplement varchar(200),
    primary key(id_plat),
    id_categorie integer references Categorie(id_categorie)
);

CREATE TABLE Menu(
    id_menu integer,
    prix decimal(4,2),
    nbservices integer,
    boissonscomprises integer,
    validite boolean,
    primary key(id_menu)
);

CREATE TABLE CompositionMenu(
    id_menu integer references Menu(id_menu),
    id_plat integer references Plat(id_plat),
    primary key(id_menu, id_plat)
);

CREATE TABLE Client(
    id_client integer,
    nom varchar(25),
    adresse varchar(100),
    primary key(id_client)
);

CREATE TABLE Commande(
    id_comm integer,
    date_comm date,
    total decimal(4,2),
    id_client integer references Client(id_client),
    primary key(id_comm)
);

CREATE TABLE CompositionCommande(
    id_comm integer references Commande(id_comm),
    id_menu integer references Client(id_menu),
    id_plat integer references Client(id_plat)
    primary key(id_comm, id_menu, id_plat)
);





-- Exemple (Postgresql) Fonction trigger
CREATE OR REPLACE FUNCTION tg_nbDepasse() RETURNS TRIGGER AS $tg_comp_menu$
BEGIN
IF (SELECT COUNT(CompositionMenu.id_plat) FROM CompositionMenu, Menu
   	WHERE CompositionMenu.Id_Menu = Menu.Id_Menu) > (SELECT nbServices FROM Menu, CompositionMenu
								   	WHERE CompositionMenu.Id_Menu = Menu.Id_Menu)
THEN RAISE 'Nombre services dépassé';
END IF;
RETURN NEW;
END;
$tg_comp_menu$ language plpgsql;


-- Creation d'un trigger avec Postgresql
CREATE TRIGGER tg_comp_menu 
AFTER INSERT OR UPDATE ON CompositionMenu
FOR EACH ROW EXECUTE PROCEDURE tg_nbdepasse();


-- FUNCTION Trigger qui met a jour le total d'une commande
CREATE OR REPLACE FUNCTION tg_MAJ_Total_Commande() RETURNS TRIGGER AS $trigger2$
BEGIN
IF (SELECT COUNT(Commande.Id_Comm) from CompositionCommande, Commande, Menu
WHERE CompositionCommande.Id_Comm = Commande.Id_Comm) > 0
THEN UPDATE Commande
SET Commande.total = Commande.total + (SELECT DISTINCT Menu.prix FROM Menu, CompositionCommande
                        WHERE Menu.Id_Menu = CompositionCommande.Id_Menu)
FROM CompositionCommande
WHERE Commande.Id_Comm = CompositionCommande.Id_Comm;
END IF;
RETURN NEW;
END;
$trigger2$ language plpgsql;   
 

-- Crettioion du trigger
CREATE TRIGGER trigger2
AFTER INSERT ON CompositionCommande
FOR EACH ROW EXECUTE PROCEDURE tg_MAJ_Total_Commande();





                                       




