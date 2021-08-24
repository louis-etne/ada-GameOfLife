with Ada.Text_IO;

procedure Main is
    use Ada.Text_IO;

    Width  : constant := 10;
    Height : constant := 10;

    type Cell_Type is (Alive, Dead);
    type Row_Type is mod Width;
    type Col_Type is mod Height;
    type Neighbors_Count_Type is range 0 .. 8;
    type Board_Type is array (Row_Type, Col_Type) of Cell_Type;

    Board : Board_Type := (
        ( Dead, Alive,  Dead, others => Dead), 
        ( Dead,  Dead, Alive, others => Dead), 
        (Alive, Alive, Alive, others => Dead), 
        others => (others => Dead) 
    );

    procedure Display_Board is
    begin 
        for Row in Row_Type loop
            for Col in Col_Type loop
                case Board (Row, Col) is
                    when Alive => Put (" # ");
                    when Dead => Put (" . ");
                end case;
            end loop;
            New_Line;
        end loop;
    end Display_Board;

    function Count_Alive_Neighbors (Row : Row_Type; Col : Col_Type) 
    return Neighbors_Count_Type is
        Count : Neighbors_Count_Type := 0;

        Shifted_Row : Row_Type;
        Shifted_Col : Col_Type;
    begin
        for Delta_Row in Row_Type range 0 .. 2 loop
            for Delta_Col in Col_Type range 0 .. 2 loop
                if Delta_Row /= 1 or else Delta_Col /= 1 then
                    Shifted_Row := Row + Delta_Row - 1;
                    Shifted_Col := Col + Delta_Col - 1;

                    if Board (Shifted_Row, Shifted_Col) = Alive then
                        Count := Count + 1;
                    end if;
                end if;
            end loop;
        end loop;

        return Count;
    end Count_Alive_Neighbors;

    procedure Next is
        Next_Board : Board_Type;
    begin
        for Row in Row_Type loop
            for Col in Col_Type loop
                case Board (Row, Col) is
                    when Alive =>
                        if Count_Alive_Neighbors (Row, Col) in 2 .. 3 then
                            Next_Board (Row, Col) := Alive;
                        else
                            Next_Board (Row, Col) := Dead;
                        end if;
                    when Dead =>
                        if Count_Alive_Neighbors (Row, Col) = 3 then
                            Next_Board (Row, Col) := Alive;
                        else 
                            Next_Board (Row, Col) := Dead;
                        end if;
                end case;
            end loop;
        end loop;

        Board := Next_Board;
    end Next;

begin

    loop
        Display_Board;
        Next;
        New_Line;
        
        delay 0.3;
    end loop;

end Main;