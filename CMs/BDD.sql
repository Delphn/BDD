-- Formule pour un Trigger d'Ordre
CREATE TRIGGER nom_du_trigger type_interposition type_ordre
    ON nom_de_la_table
    <action>

type_interposition: BEFORE, AFTER

type_ordre: INSERT, UPDATE, DELETE, type_ordre OR type_ordre, UPDATE OF liste_de_colonnes.

-- Example (Oracle)
CREATE TRIGGER tg_modifInterdit
    AFTER UPDATE OF prix, qte ON vente
    BEGIN
        raise_application_error(-9998, 'Modification interdite');
    END;



-- Trigger Ligne (FOR EACH ROW)
CREATE TRIGGER nom_du_trigger type_interposition type_ordre ON nom_de_la_table
FOR EACH ROW
    <action>

-- Exemple (Oracle)
CREATE TRIGGER tg_nouvVente AFTER INSERT ON vente
FOR EACH ROW
    BEGIN
        if :new.qte > (select qte from Stock where gencod = :new.gencod)
        then raise_application_error(-9997, 'Stock insufisant');
        else update Stock set qte := Stock.qte - :new.qte
                where gencod = :new.gencod;
    END;
