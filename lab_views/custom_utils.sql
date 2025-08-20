-- A custom function for calculating a given age at a given date of visit in days. 

CREATE OR REPLACE FUNCTION age_days_between(date1 DATE, date2 DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN date2 - date1;
END;
$$ LANGUAGE plpgsql;