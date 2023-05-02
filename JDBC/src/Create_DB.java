import java.sql.*;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Scanner;

public class Create_DB {

    public static void printQueries() {
        System.out.println("1. Search students by name.");
        System.out.println("2. Search students by year.");
        System.out.println("3. Search for students with a GPA >= threshold.");
        System.out.println("4. Search for students with a GPA <= threshold.");
        System.out.println("5. Get Department Statistics.");
        System.out.println("6. Get Class Statistics.");
        System.out.println("7. Execute an arbitrary SQL query.");
        System.out.println("8. Exit the application.");
    }
    
    public static int countSet(ResultSet cs) throws Exception {
        int count = 0;
        while (cs.next()) count++;
        return count;
    }

    public static double calculateGpa(Statement stmt, int id) throws Exception {
        ResultSet rs1 = stmt.executeQuery("SELECT DISTINCT sid FROM hasTaken ORDER BY sid");
        ArrayList <Integer> r = new ArrayList<>();
        while (rs1.next()) r.add(rs1.getInt(1));
        boolean notThere = true;
        for (int i = 0; i < r.size(); i++) {
            if (r.get(i) == id) {
                notThere = false;
                break;
            }
        }
        if (notThere) return 0;
        ResultSet rsgpa = stmt.executeQuery("SELECT grade FROM hasTaken WHERE sid = " + id);
        double count = 0, sum = 0;
        while (rsgpa.next()) {
            if (rsgpa.getString(1).equals("A")) sum += 4;
            else if (rsgpa.getString(1).equals("B")) sum += 3;
            else if (rsgpa.getString(1).equals("C")) sum += 2;
            else if (rsgpa.getString(1).equals("D")) sum += 1;
            else sum += 0;
            count++;
        }
        rsgpa.close();
        return sum/count;
    }

    public static int getCredits(Statement stmt, int id) throws Exception {
        ResultSet rscreds = stmt.executeQuery("SELECT sum(credits) FROM classes C "
        + "JOIN hasTaken H ON C.name = H.name "
        + "WHERE H.sid = " + id);
        int a = 0;
        if (rscreds.next()) a = rscreds.getInt(1);
        rscreds.close();
        return a;
    }

    public static ResultSet searchStudents (ResultSet rs, Statement stmt, String name) throws Exception {
        return rs = stmt.executeQuery("SELECT * FROM students "+ 
        "WHERE first_name LIKE '%" + name + "%'" +
        " OR last_name LIKE '%" + name + "%'");
    }
    
    public static ResultSet searchYear (ResultSet rs, Statement stmt, String year) throws Exception {
        if (year.equals("Fr")) {
            return rs = stmt.executeQuery("SELECT S.first_name, S.last_name, "
            + "S.id, sum(C.credits) FROM Students S "
            + "JOIN hasTaken H ON H.sid = S.id "
            + "JOIN classes C ON C.name = H.name "
            + "GROUP BY S.id HAVING sum(C.credits) BETWEEN 0 AND 29");
        } else if (year.equals("So")) {
            return rs = stmt.executeQuery("SELECT S.first_name, S.last_name, "
            + "S.id, sum(C.credits) FROM Students S "
            + "JOIN hasTaken H ON H.sid = S.id "
            + "JOIN classes C ON C.name = H.name "
            + "GROUP BY S.id HAVING sum(C.credits) BETWEEN 30 AND 59");
        } else if (year.equals("Ju")) {
            return rs = stmt.executeQuery("SELECT S.first_name, S.last_name, "
            + "S.id, sum(C.credits) FROM Students S "
            + "JOIN hasTaken H ON H.sid = S.id "
            + "JOIN classes C ON C.name = H.name "
            + "GROUP BY S.id HAVING sum(C.credits) BETWEEN 60 AND 89");
        } else if (year.equals("Sr")){
            return rs = stmt.executeQuery("SELECT S.first_name, S.last_name, "
            + "S.id, sum(C.credits) FROM Students S "
            + "JOIN hasTaken H ON H.sid = S.id "
            + "JOIN classes C ON C.name = H.name "
            + "GROUP BY S.id HAVING sum(C.credits) BETWEEN 90 AND 150");
        }
        else return rs = stmt.executeQuery ("SELECT id FROM students WHERE id = -1");
    }

    public static ResultSet searchGpa (ResultSet rs, Statement stmt, Connection conn, double gpa,
    boolean isGreater) throws Exception {
        ResultSet rsids = stmt.executeQuery("SELECT id FROM students");
        ArrayList <Integer> al = new ArrayList<>();
        Statement stmt2 = conn.createStatement();
        int j = 1;
        while (rsids.next()) {
            if (isGreater) {
                if (calculateGpa(stmt2, j) >= gpa) al.add(rsids.getInt(1));
            } else {
                if (calculateGpa(stmt2, j) <= gpa) al.add(rsids.getInt(1));
            }
            j++;
        }
        rsids.close();
        if (al.size() == 0) return rs = stmt.executeQuery("SELECT id FROM students WHERE id = -1");
        int[] ala = new int[al.size()];
        StringBuilder s = new StringBuilder();
        for (int i = 0; i < al.size(); i++) {
            ala[i] = al.get(i);
            if (i == al.size()-1) s.append(ala[i]);
            else s.append(ala[i] + ", ");
        }
        String values = s.toString();
        return rs = stmt.executeQuery("SELECT * FROM students WHERE id IN("+ values + ")");
    }

    public static void depStats(Statement stmt, Connection conn, String dep) throws Exception{
        ArrayList <Integer> al = new ArrayList<>();
        ResultSet majs = stmt.executeQuery("SELECT sid FROM majors WHERE dname = '" + dep +"'");
        while (majs.next()) al.add(majs.getInt(1));
        majs.close();
        ResultSet mins = stmt.executeQuery("SELECT sid FROM minors WHERE dname = '" + dep +"'");
        while (mins.next()) al.add(mins.getInt(1));
        mins.close();
        double[] gpas = new double[al.size()];
        Statement stmt2 = conn.createStatement();
        for (int i = 0; i < al.size(); i++) gpas[i] = calculateGpa(stmt2, al.get(i));
        double sum = 0;
        for (double i : gpas) sum += i;
        System.out.println("Num students: " + al.size());
        System.out.println("Average Gpa: " + (sum/al.size()));
    }

    public static void classStats(Statement stmt, String classname) throws Exception {
        ResultSet currStuds = stmt.executeQuery("SELECT count(*) FROM isTaking WHERE name = '" 
        + classname +"'");
        if (currStuds.next()) System.out.println(currStuds.getInt(1) + " students currently enrolled");
        currStuds.close();
        
        System.out.println("Grades of previous enrollees:");
        
        ResultSet AStuds = stmt.executeQuery("SELECT count(*) FROM hasTaken WHERE " +
        "grade = 'A' AND name = '" + classname + "'");
        if(AStuds.next()) System.out.println("A " + AStuds.getInt(1));
        AStuds.close();

        ResultSet BStuds = stmt.executeQuery("SELECT count(*) FROM hasTaken WHERE " +
        "grade = 'B' AND name = '" + classname + "'");
        if(BStuds.next()) System.out.println("B " + BStuds.getInt(1));
        BStuds.close();

        ResultSet CStuds = stmt.executeQuery("SELECT count(*) FROM hasTaken WHERE " +
        "grade = 'C' AND name = '" + classname + "'");
        if(CStuds.next()) System.out.println("C " + CStuds.getInt(1));
        CStuds.close();

        ResultSet DStuds = stmt.executeQuery("SELECT count(*) FROM hasTaken WHERE " +
        "grade = 'D' AND name = '" + classname + "'");
        if(DStuds.next()) System.out.println("D " + DStuds.getInt(1));
        DStuds.close();

        ResultSet FStuds = stmt.executeQuery("SELECT count(*) FROM hasTaken WHERE " +
        "grade = 'F' AND name = '" + classname + "'");
        if(FStuds.next()) System.out.println("F " + FStuds.getInt(1));
        FStuds.close();
    }

    public static void printQuery (Statement stmt, String s) throws Exception {
        try {
            ResultSet rs = stmt.executeQuery(s);
            ResultSetMetaData rsmd = rs.getMetaData(); 
            int column = rsmd.getColumnCount();
            for (int i = 1; i <= column; i++) System.out.print(rsmd.getColumnName(i) + "\t");
            System.out.println();
            while (rs.next()) {
                for (int i = 1; i <= column; i++) {
                    System.out.print(rs.getString(i) + "\t");
                }
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("SQLException: " + e);
        }
    } 

    public static void main(String[] args) throws Exception {
        try (
                Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://" + args[0],
                        args[1], args[2]);
                Statement stmt = conn.createStatement();
                Statement Stmt = conn.createStatement();) {
            try {
                ResultSet rs = null;
                ResultSet cs = null;
                System.out.println("Welcome to the university database. Queries Available:");
                Scanner query = new Scanner(System.in);
                int queryNum = 0;
                int queryNumm = 0;
                printQueries();
                while (queryNum != 8) {
                    System.out.println("Which query would you like to run (1-8)?");
                    queryNum = Integer.parseInt(query.nextLine());
                    switch (queryNum) {
                        case 1:
                            queryNumm = queryNum;
                            System.out.println("Please enter the name.");
                            String name = query.nextLine();
                            rs = searchStudents(rs, stmt, name);
                            cs = searchStudents(cs, Stmt, name);
                            break;
                        case 2:
                            queryNumm = queryNum;
                            System.out.println("Please enter the year");
                            String yr = query.nextLine();
                            rs = searchYear(rs, stmt, yr);
                            cs = searchYear(cs, Stmt, yr);
                            break;
                        case 3:
                            queryNumm = queryNum;
                            System.out.println("Please enter the threshold.");
                            double gpa = Double.parseDouble(query.nextLine());
                            rs = searchGpa(rs, stmt, conn, gpa, true);
                            cs = searchGpa(cs, Stmt, conn, gpa, true);
                            break;
                        case 4:
                            queryNumm = queryNum;
                            System.out.println("Please enter the threshold.");
                            double gpa2 = Double.parseDouble(query.nextLine());
                            rs = searchGpa(rs, stmt, conn, gpa2, false);
                            cs = searchGpa(cs, Stmt, conn, gpa2, false);
                            break;
                        case 5:
                            queryNumm = queryNum;
                            System.out.println("Please enter the department.");
                            String dep = query.nextLine();
                            depStats(stmt, conn, dep);
                            break;
                        case 6:
                            queryNumm = queryNum;
                            System.out.println("Please enter the class name.");
                            String classname = query.nextLine();
                            classStats(stmt, classname);
                            break;
                        case 7:
                            queryNumm = queryNum;
                            System.out.println("Please enter the query");
                            String quero = query.nextLine();
                            printQuery(stmt, quero);
                            break;
                        default:                        
                            break;
                    }
                    if (queryNumm == 1 || queryNumm == 2 || queryNumm == 3 || queryNumm == 4) {
                        int count = countSet(cs);
                        if (cs == null || count == 0) System.out.println("0 students found");
                        else {
                            System.out.println(countSet(cs) + " students found");
                            while (rs.next()) {
                                Statement stmt2 = conn.createStatement();
                            
                                int id = rs.getInt(3);
                                System.out.print(rs.getString(1) + ", " +rs.getString(2) + "\n");
                                System.out.println("ID: " + id);

                                ResultSet major = stmt2.executeQuery("SELECT dname FROM majors " +
                                "WHERE sid = " + id);
                                if (major.next())System.out.println("Major: " + major.getString(1));
                                major.close();

                                ResultSet minor = stmt2.executeQuery("SELECT dname FROM minors " +
                                "WHERE sid = " + id);
                                if (minor.next())System.out.println("Minor: " + minor.getString(1));
                                minor.close();
                                
                                System.out.println("GPA: " + calculateGpa(stmt2, id));

                                System.out.println("Credits: " + getCredits(stmt2, id));
                                System.out.println();
                            }
                        }
                    }
                }
                System.out.println("Goodbye.");
            } catch (SQLException e) {
                System.out.println("SQLException : " + e);
            }
            conn.close();
        } catch (Exception e) {
            System.out.println("Exception : " + e);
        }
    } 
}
