import Data.List
import Data.List.Split
import System.IO

-- Data type for disponibilities, contains names and list of possible times
data Disp = Disp {name::String, disp::[Int]} deriving (Show, Eq)

-- Sort the disponibilities according to the number of possible times
sortDisp :: [Disp] -> [Disp]
sortDisp = sortBy (\x y ->  compare (length $ disp x) (length $ disp y) )

-- Finds a suitable time for everyone
findpath :: [Disp] -> [Int] -> [Disp]
findpath (x:rest) free  -- person in the middle of the list
 | poss == [] = [] -- no possibilities, return empty list
 | rest == [] = [solution] -- Last person, return a solution
 | next /= [] = solution:next -- the next people can accomodate your first possibility, return that solution
 | otherwise  = findpath (( Disp (name x) (tail poss) ):rest) free -- the next people cannot accomodate, try next possibility
  where poss = intersect (disp x) free
        solution =  Disp (name x) [head poss]
        next = findpath rest newfree
        newfree = filter (/= head poss) free

-- Transforms the text from the csv file into a list fo disponibilities
csvToDisp :: String -> [Disp]
csvToDisp = map (lstToDisp) . map (splitOn ",") . lines
  where lstToDisp lst = Disp (head lst) (findIndices (\x -> x/="" && x/="\r") $ tail lst)

-- Fills the list of disponibilities with enpty ones to match the list of times
fillDisp :: [Disp] -> Int -> Int -> [Disp]
fillDisp [] n m = replicate (m-n) (Disp "" [])
fillDisp dall@(d0:d) n m
  | n == m = []
  | n == (head $ disp d0) = d0:fillDisp d (n+1) m
  | otherwise    = (Disp "" []):fillDisp dall (n+1) m

-- Builds the solution in a CSV format (time, name)
solToCSV :: [Disp] -> [String]  -> String
solToCSV [] [] = ""
solToCSV [] (t0:t) = t0 ++ "\n" ++ solToCSV [] t
solToCSV x []  = solToCSV filled times
  where times = [ (show hour) ++ ":" ++ minute ++ "," | day <-[1,2] ,
            hour <- [9..18], minute <- ["00","30"] , (hour/=18 || minute/="30") && (hour/=9 || minute/="00") ]
        ordered = sortBy (\a b ->  compare (disp a) (disp b) ) x
        filled = fillDisp ordered 0 (length times)
solToCSV (d0:d) (t0:t) = t0 ++ (name d0) ++ "\n" ++ solToCSV d t

main = do
    contents <- readFile "20161226Doodle.csv"
    let dispo = csvToDisp contents
        poss = map (subtract 18) ([18,19]++[21,22]++[24,25]++[27,28]++[30..35])-- available time slots
        sol = findpath dispo poss
    writeFile "output.csv" $ solToCSV sol []
    putStrLn $ solToCSV sol []
