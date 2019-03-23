CREATE TABLE Commande(
    id_comm integer,
    date_comm date,
    total DECIMAL(2),
    id_client integer references  ,
    CONSTRAINT commande_pkey PRIMARY KEY (id_comm),
    CONSTRAINT commande_id_client_fkey FOREIGN KEY (id_client)
        REFERENCES public.client (id_client) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);



-- Exemple (Postgresql) Fonction trigger
CREATE OR REPLACE FUNCTION tg_nbDepasse() RETURNS TRIGGER AS $tr1$
BEGIN
IF (SELECT COUNT(CompositionMenu.id_plat) FROM CompositionMenu, Menu
   	WHERE CompositionMenu.Id_Menu = Menu.Id_Menu) > (SELECT DISTINCT nbServices FROM Menu, CompositionMenu
								   	WHERE CompositionMenu.Id_Menu = Menu.Id_Menu)
THEN RAISE 'Nombre services atteint';
END IF;
RETURN NEW;
END;


-- Creation d'un trigger avec Postgresql
CREATE TRIGGER tr1 
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





                                       




