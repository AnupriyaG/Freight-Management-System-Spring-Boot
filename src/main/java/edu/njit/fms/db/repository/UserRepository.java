package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

import edu.njit.fms.db.entity.User;

public interface UserRepository extends CrudRepository<User, Long> {
    List<User> listAllUsers();
    String getUserGroup(String loginID);
    String getUserAgencyAlias(String loginID);
    String getUserEmail(String loginID);
    String getUserFullName(String loginID);
    String getUserPassword(String loginID);
    List<String> getGroupList();

    @Query(value = "select count(*) as count from principle where loginid = ?1", nativeQuery = true)
    int validateUsername(String loginid);
    
    @Query(value = "select PT.value from principle P,profiletable PT " + 
    "where P.loginid=PT.loginid and (PT.name='emailFrom' or PT.name = 'userGroup' or PT.name='agencyAlias') " +
    "and P.loginid = ?1", nativeQuery = true)
    List<String> selectForDeleteConfirm(String loginID);

    @Modifying
    @Transactional
    @Query(value = "insert into groupmap values('xeno',?1,?2)", nativeQuery = true)
    void insertGroupMap(String group, String userID);

    @Modifying
    @Transactional
    @Query(value = "insert into principle values('xeno',?1,?2,?3,0)", nativeQuery = true)
    void insertPrinciple(String userID, String fullName, String password);

    @Modifying
    @Transactional
    @Query(value = "insert into profiletable values('xeno',?1,'userGroup',?2,0)", nativeQuery = true)
    void insertProfileTable1(String userID, String group);

    @Modifying
    @Transactional
    @Query(value = "insert into profiletable values('xeno',?1,'agencyAlias','NJDOT',0)", nativeQuery = true)
    void insertProfileTable2(String userID);

    @Modifying
    @Transactional
    @Query(value = "insert into profiletable values('xeno',?1,'emailFrom',?2,0)", nativeQuery = true)
    void insertProfileTable3(String userID, String email);

/*     String groupmap_delete = "";
			String principle_delete = "";
            String profiletable_delete = ""; */
            
    @Modifying
    @Transactional
    @Query(value = "delete from groupmap where principleid = ?1", nativeQuery = true)
    void deleteFromGroupMap(String userID);

    @Modifying
    @Transactional
    @Query(value = "delete from principle where loginid = ?1", nativeQuery = true)
    void deleteFromPrinciple(String userID);

    @Modifying
    @Transactional
    @Query(value = "delete from profiletable where loginid = ?1", nativeQuery = true)
    void deleteFromProfileTable(String userID);

}