
--------------------------------------------------------------------------------------------------------------	
	INSERT INTO [CareWebQIDb].[iCCG].[ProgramGuideline]
           ([ProgramID]
           ,[GuidelineTitle]
           ,[ProductCode]
           ,[HSIM]
           ,[Ordinal]
           ,[IsEnrollment]
           ,[Active]
           ,[InsertDate]
           ,[InsertBy]
           ,[UpdateDate]
           ,[UpdateBy])
     VALUES
           (2
           ,'Content Merge Guideline'
           ,'CCG'
           ,'iccg_777'
           ,1
           ,0
           ,1
           ,'2/27/12 2:10pm'
           ,1
           ,null
           ,null)	   

---------------------------------------------------------------------------------------------
INSERT INTO [CareWebQIDb].[dbo].[ContentVersion]
           ([Name]
           ,[DisplayName]
           ,[Active]
           ,[VersionNumber]
           ,[ContentVersionPath]
           ,[UserContentPath]
           ,[InstallDate]
           ,[ActiveDate]
           ,[InactiveDate]
           ,[SortOrder]
           ,[ReleaseOrder]
           ,[ContentEditionID])
     VALUES
           ('16th Edition'
           ,'Milliman Care Guidelines 16th Edition'
           ,1
           ,16.0
           ,'C:\Program Files\Milliman Care Guidelines\CareWebQI\Content\Milliman\16.0'
           ,''
           ,NULL
           ,'2011-09-12 09:03:52.000'
           ,NULL
           ,1
           ,1
           ,16)
------------------------------------------------------------------------------------------------------
INSERT INTO [CONTENT1067].[content].[Guidelines]
           ([GuidelineTitle]
           ,[ProductCode]
           ,[Version]
           ,[ContentOwner]
           ,[HSIM]
           ,[GuidelineCode]
           ,[GuidelineType]
           ,[ChronicCondition]
           ,[GLOS]
           ,[GuidelineXML]
           ,[GLOSXML]
           ,[GLOSMin]
           ,[GLOSMax]
           ,[GLOSType]
           ,[VersionMajor]
           ,[VersionMinor])
     VALUES
           ('Content Merge Guideline'
           ,'CCG'
           ,'16.0'
           ,'GA'
           ,'iccg_777'
           ,' '
           ,'iccg_dm'
           ,'False'
           ,Null
           ,'<sections>
				<section Heading="TestSection" LogicType="1" Path="/TestSection" DisplayOrder="1">
					<section Heading="TestSection2" LogicType="2" Path="/TestSection/TestSection2" DisplayOrder="1" />
				</section>
			 </sections>'
           ,Null
           ,Null
           ,Null
           ,Null
           ,16
           ,0)
-----------------------------------------------------------------------------------------------------------

INSERT INTO [CONTENT1067].[content].[Sections]
           ([HSIM]
           ,[ProductCode]
           ,[ContentVersion]
           ,[ContentOwner]
           ,[SectionPath]
           ,[SectionXML]
           ,[ProgressionPeriod]
           ,[ProgressionBehavior]
           ,[DisplayOrder]
           ,[VersionMajor]
           ,[VersionMinor])
     VALUES
          ( 'iccg_777'
           ,'CCG'
           ,16.0
           ,'GA'
           ,'/TestSection'
            ,'<guideline-sect2 contentsource="38" contenttype="Section" displayorder="9" id="Behavioral_iccg_105" idsection="340795" logic_type="1" role="TestSection">
  <heading>TestSection</heading>
  <guideline-sect3 astoriaid="00000018WGA51F3GYZ" contentsource="1" contenttype="Section" displayorder="1" id="Alcohol Abuse_iccg_105" idsection="340796" logic_type="5" role="TestSection2">
    <heading>TestSection2</heading>
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_5_1_143" uid="103">
      <para>(V16.0) Question uid777100</para>
      <answer logic-note="STOP" uid="777200">
        <para>(V16.0) Answer 777200</para>
      </answer>      
      <answer uid="777201">
        <para>(V16.0) Answer uid777201</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
	  <answer uid="777202">
        <para>(V16.0) Answer uid777202</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
      <answer uid="777203">
        <para>(V16.0) Answer uid777203</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
      <answer uid="777204">
        <para>(V16.0) Answer uid777204</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
      <answer logic-note="STOP" uid="777205">
        <para>(V16.0) Answer uid777205</para>
      </answer>
    </question>

	
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_22_2_143" uid="777101">
      <para>(V16.0) Question uid777101</para>
      <answer uid="777206">
        <para>(V16.0) answer uid777206</para>
      </answer>

      <answer uid="777207">
        <para>(V16.0) answer uid777207</para>        
		<problemref linkend="p_iccg_034_29_4_144" uid="777300" />
      </answer>

      <answer uid="777208">
        <para>(V16.0) answer 777208</para>
        <problemref linkend="p_iccg_034_29_4_144" uid="777300" />
      </answer>

      <answer uid="777209">
        <para>(V16.0) answer uid777209</para>
         <problemref linkend="p_iccg_034_29_4_144" uid="777300" />
      </answer>
    
	<answer uid="777210">
        <para>(V16.0) answer uid777210</para>
        <problemref linkend="p_iccg_034_29_4_144" uid="777300" />
      </answer>

      <answer uid="777211">
        <para>(V16.0) answer uid777211</para>
      </answer>
    </question>    


	<problem id="p_iccg_034_29_4_144" uid="777300">
      <para>(V16.0) Problem uid777300</para>
      <note type="evidence">Evidence Text 01 problem uid777300<citation db_id="79156" linkend="cit_iccg_042_001" cl="cl_c_48" display_value="13" /> Evidence Text 02 problem uid777300.<citation db_id="51269" linkend="cit_iccg_042_002" cl="cl_c_49" display_value="14" /> Evidence Text 03 problem uid777300<citation db_id="79141" linkend="cit_iccg_042_003" cl="cl_c_50" display_value="15" /></note>

      <goal uid="777400">
        <para>(V16.0) Goal uid777400</para>
        <intervention type="assist" uid="777500">
          <para>(V16.0) Intervention uid777500.</para>
        </intervention>        
        <intervention type="send" uid="777501">
          <para>(V16.0) Intervention uid501 with web link
            <ulink url="pted_641.pdf" product="ccg" hsim="pted_641" sp_url="/sp_pted/pted_641_esp.pdf">Websites - Substance abuse</ulink>
          </para>
        </intervention>
      </goal>

      <goal uid="777401">
        <para>(V16.0) Goal uid777401.</para>
        <intervention type="educate" uid="777502">
          <para>(V16.0) Intervention uid777502</para>
        </intervention>
        <intervention type="educate" uid="777503">
          <para>(V16.0) Intervention uid777503</para>
        </intervention>
        <intervention type="educate" uid="777504">
          <para>(V16.0) Intervention uid777504</para>
        </intervention>
        <intervention type="educate" uid="777505">
          <para>(V16.0) Intervention uid777505</para>
        </intervention>
      </goal>

	  <goal uid="777402">
        <para>(V16.0) Goal uid777402</para>
        <intervention type="educate" uid="777506">
          <para>(V16.0) Intervention uid777506</para>
        </intervention>
        <intervention type="educate" uid="777507">
          <para>(V16.0) Intervention uid777507</para>
        </intervention>        
      </goal>

	  <goal uid="777403">
        <para>(V16.0) Goal uid777403</para>
        <intervention type="educate" uid="777508">
          <para>(V16.0) Intervention uid777508</para>
        </intervention>
        <intervention type="educate" uid="777509">
          <para>(V16.0) Intervention uid777509</para>
        </intervention>        
      </goal>
	  
	  </problem>
  </guideline-sect3>  
</guideline-sect2>'
           ,NULL
           ,NULL
           ,1
           ,16
           ,0)
------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [CONTENT1067].[content].[Sections]
           ([HSIM]
           ,[ProductCode]
           ,[ContentVersion]
           ,[ContentOwner]
           ,[SectionPath]
           ,[SectionXML]
           ,[ProgressionPeriod]
           ,[ProgressionBehavior]
           ,[DisplayOrder]
           ,[VersionMajor]
           ,[VersionMinor])
     VALUES
          ( 'iccg_777'
           ,'CCG'
           ,16.0
           ,'GA'
           ,'/TestSection/TestSection2'
           ,'  <guideline-sect3 astoriaid="00000018WGA51F3GYZ" contentsource="1" contenttype="Section" displayorder="1" id="Alcohol Abuse_iccg_105" idsection="340796" logic_type="5" role="TestSection2">
 
 <heading>TestSection2</heading>
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_5_1_143" uid="777100">
      <para>(V16.0) Question uid777100</para>
      <answer logic-note="STOP" uid="777200">
        <para>(V16.0) Answer 777200</para>
      </answer>      
      <answer uid="777201">
        <para>(V16.0) Answer uid777201</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
	  <answer uid="777202">
        <para>(V16.0) Answer uid777202</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
      <answer uid="777203">
        <para>(V16.0) Answer uid777203</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
      <answer uid="777204">
        <para>(V16.0) Answer uid777204</para>
        <questionref linkend="q_iccg_034_22_2_143" uid="104" />
      </answer>
      <answer logic-note="STOP" uid="777205">
        <para>(V16.0) Answer uid777205</para>
      </answer>
    </question>

	
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_22_2_143" uid="777101">
      <para>(V16.0) Question uid777101</para>
      <answer uid="777206">
        <para>(V16.0) answer uid777206</para>
      </answer>

      <answer uid="777207">
        <para>(V16.0) answer uid777207</para>        
		<problemref linkend="p_iccg_034_29_4_144" uid="21" />
      </answer>

      <answer uid="777208">
        <para>(V16.0) answer 777208</para>
        <problemref linkend="p_iccg_034_29_4_144" uid="21" />
      </answer>

      <answer uid="777209">
        <para>(V16.0) answer uid777209</para>
         <problemref linkend="p_iccg_034_29_4_144" uid="21" />
      </answer>
    
	<answer uid="777210">
        <para>(V16.0) answer uid777210</para>
        <problemref linkend="p_iccg_034_29_4_144" uid="21" />
      </answer>

      <answer uid="777211">
        <para>(V16.0) answer uid777211</para>
      </answer>
    </question>    


	<problem id="p_iccg_034_29_4_144" uid="777300">
      <para>(V16.0) Problem uid777300</para>
      <note type="evidence">Evidence Text 01 problem uid777300<citation db_id="79156" linkend="cit_iccg_042_001" cl="cl_c_48" display_value="13" /> Evidence Text 02 problem uid777300.<citation db_id="51269" linkend="cit_iccg_042_002" cl="cl_c_49" display_value="14" /> Evidence Text 03 problem uid777300<citation db_id="79141" linkend="cit_iccg_042_003" cl="cl_c_50" display_value="15" /></note>

      <goal uid="777400">
        <para>(V16.0) Goal uid777400</para>
        <intervention type="assist" uid="777500">
          <para>(V16.0) Intervention uid777500.</para>
        </intervention>        
        <intervention type="send" uid="777501">
          <para>(V16.0) Intervention uid501 with web link
            <ulink url="pted_641.pdf" product="ccg" hsim="pted_641" sp_url="/sp_pted/pted_641_esp.pdf">Websites - Substance abuse</ulink>
          </para>
        </intervention>
      </goal>

      <goal uid="777401">
        <para>(V16.0) Goal uid777401.</para>
        <intervention type="educate" uid="777502">
          <para>(V16.0) Intervention uid777502</para>
        </intervention>
        <intervention type="educate" uid="777503">
          <para>(V16.0) Intervention uid777503</para>
        </intervention>
        <intervention type="educate" uid="777504">
          <para>(V16.0) Intervention uid777504</para>
        </intervention>
        <intervention type="educate" uid="777505">
          <para>(V16.0) Intervention uid777505</para>
        </intervention>
      </goal>

	  <goal uid="777402">
        <para>(V16.0) Goal uid777402</para>
        <intervention type="educate" uid="777506">
          <para>(V16.0) Intervention uid777506</para>
        </intervention>
        <intervention type="educate" uid="777507">
          <para>(V16.0) Intervention uid777507</para>
        </intervention>        
      </goal>

	  <goal uid="777403">
        <para>(V16.0) Goal uid777403</para>
        <intervention type="educate" uid="777508">
          <para>(V16.0) Intervention uid777508</para>
        </intervention>
        <intervention type="educate" uid="777509">
          <para>(V16.0) Intervention uid777509</para>
        </intervention>        
      </goal>
	  
	  </problem>
	</guideline-sect3>'
           ,NULL
           ,NULL
           ,2
           ,16
           ,0)