export IndiaNSECalendar

abstract IndiaCalendar <: WesternCalendar

type IndiaNSECalendar <: IndiaCalendar; end

string(::IndiaNSECalendar) = "National Stock Exchange of India (Equities Trading)"

function isWorkingDay(c::IndiaNSECalendar, dt::CalendarTime)
	d=day(dt)
	dd=dayofyear(dt)
	m=month(dt)
	w=dayofweek(dt)
	y=year(dt)
	em=easterMonday(c,y)

	if (isWeekend(c,w)
            # Republic Day
            || (d == 26 && m == January)
            # Good Friday
            || (dd == em-3)
            # Ambedkar Jayanti
            || (d == 14 && m == April)
            # Independence Day
            || (d == 15 && m == August)
            # Gandhi Jayanti
            || (d == 2 && m == October)
            # Christmas
            || (d == 25 && m == December))
            
            return false
    end

         if (y == 2005) 
            # Moharram, Holi, Maharashtra Day, and Ramzan Id fall
            # on Saturday or Sunday in 2005
            if (# Bakri Id
                (d == 21 && m == January)
                # Ganesh Chaturthi
                || (d == 7 && m == September)
                # Dasara
                || (d == 12 && m == October)
                # Laxmi Puja
                || (d == 1 && m == November)
                # Bhaubeej
                || (d == 3 && m == November)
                # Guru Nanak Jayanti
                || (d == 15 && m == November))
                
                return false
            end
        end

        if (y == 2006) 
            if (# Bakri Id
                (d == 11 && m == January)
                # Moharram
                || (d == 9 && m == February)
                # Holi
                || (d == 15 && m == March)
                # Ram Navami
                || (d == 6 && m == April)
                # Mahavir Jayanti
                || (d == 11 && m == April)
                # Maharashtra Day
                || (d == 1 && m == May)
                # Bhaubeej
                || (d == 24 && m == October)
                # Ramzan Id
                || (d == 25 && m == October))
                
                return false
            end
        end

        if (y == 2007) 
            if (# Bakri Id
                (d == 1 && m == January)
                # Moharram
                || (d == 30 && m == January)
                # Mahashivratri
                || (d == 16 && m == February)
                # Ram Navami
                || (d == 27 && m == March)
                # Maharashtra Day
                || (d == 1 && m == May)
                # Buddha Pournima
                || (d == 2 && m == May)
                # Laxmi Puja
                || (d == 9 && m == November)
                # Bakri Id (again)
                || (d == 21 && m == December))
                
                return false
            end
        end

        if (y == 2008) 
            if (# Mahashivratri
                (d == 6 && m == March)
                # Id-E-Milad
                || (d == 20 && m == March)
                # Mahavir Jayanti
                || (d == 18 && m == April)
                # Maharashtra Day
                || (d == 1 && m == May)
                # Buddha Pournima
                || (d == 19 && m == May)
                # Ganesh Chaturthi
                || (d == 3 && m == September)
                # Ramzan Id
                || (d == 2 && m == October)
                # Dasara
                || (d == 9 && m == October)
                # Laxmi Puja
                || (d == 28 && m == October)
                # Bhau bhij
                || (d == 30 && m == October)
                # Gurunanak Jayanti
                || (d == 13 && m == November)
                # Bakri Id
                || (d == 9 && m == December))
                
                return false
            end
        end

        if (y == 2009) 
            if (# Moharram
                (d == 8 && m == January)
                # Mahashivratri
                || (d == 23 && m == February)
                # Id-E-Milad
                || (d == 10 && m == March)
                # Holi
                || (d == 11 && m == March)
                # Ram Navmi
                || (d == 3 && m == April)
                # Mahavir Jayanti
                || (d == 7 && m == April)
                # Maharashtra Day
                || (d == 1 && m == May)
                # Ramzan Id
                || (d == 21 && m == September)
                # Dasara
                || (d == 28 && m == September)
                # Bhau Bhij
                || (d == 19 && m == October)
                # Gurunanak Jayanti
                || (d == 2 && m == November)
                # Moharram (again)
                || (d == 28 && m == December))
                
                return false
            end
        end

        if (y == 2010) 
            if (# New Year's Day
                (d == 1 && m == January)
                # Mahashivratri
                || (d == 12 && m == February)
                # Holi
                || (d == 1 && m == March)
                # Ram Navmi
                || (d == 24 && m == March)
                # Ramzan Id
                || (d == 10 && m == September)
                # Laxmi Puja
                || (d == 5 && m == November)
                # Bakri Id
                || (d == 17 && m == November)
                # Moharram
                || (d == 17 && m == December))
                
                return false
            end   
        end

        if (y == 2011) 
            if (# Mahashivratri
                (d == 2 && m == March)
                # Ram Navmi
                || (d == 12 && m == April)
                # Ramzan Id
                || (d == 31 && m == August)
                # Ganesh Chaturthi
                || (d == 1 && m == September)
                # Dasara
                || (d == 6 && m == October)
                # Laxmi Puja
                || (d == 26 && m == October)
                # Diwali - Balipratipada
                || (d == 27 && m == October)
                # Bakri Id
                || (d == 7 && m == November)
                # Gurunanak Jayanti
                || (d == 10 && m == November)
                # Moharram
                || (d == 6 && m == December))
                
                return false
             end
        end

        if (y == 2012) 
            if (# Mahashivratri
                (d == 20 && m == February)
                # Holi
                || (d == 8 && m == March)
                # Mahavir Jayanti
                || (d == 5 && m == April)
                # May Day
                || (d == 1 && m == May)
                # Ramzan Id
                || (d == 20 && m == August)
                # Ganesh Chaturthi
                || (d == 19 && m == September)
                # Dasara
                || (d == 24 && m == October)
                # Diwali - Balipratipada
                || (d == 14 && m == November)
                # Gurunanak Jayanti
                || (d == 28 && m == November))
                
                return false
             end
        end

        return true

end