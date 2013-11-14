
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
           ,'Content Merge Guideline 888'
           ,'CCG'
           ,'iccg_888'
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
           ('Content Merge Guideline 888'
           ,'CCG'
           ,'16.0'
           ,'GA'
           ,'iccg_888'
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
          ( 'iccg_888'
           ,'CCG'
           ,16.0
           ,'GA'
           ,'/TestSection'
           ,'<guideline-sect2 contentsource="38" contenttype="Section" displayorder="9" id="Behavioral_iccg_105" idsection="340795" logic_type="1" role="TestSection">
  <heading>TestSection</heading>
  <guideline-sect3 astoriaid="00000018WGA51F3GYZ" contentsource="1" contenttype="Section" displayorder="1" id="Alcohol Abuse_iccg_105" idsection="340796" logic_type="5" role="TestSection2">
    <heading>TestSection2</heading>
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_5_1_143" uid="888201">
      <para>(V16.0) Question uid 888201</para>

		<answer logic-note="STOP" uid="888201">
			<para>(V16.0) 888201</para>
		</answer>      
	 
		<answer uid="888202">
			<para>(V16.0) Answer uid 888202</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888202" />
		</answer>

		<answer uid="888203">
			<para>(V16.0) Answer uid 888203</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888203" />
		</answer>

		<answer uid="888204">
			<para>(V16.0) Answer uid 888204</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888204" />
		</answer>

		 <answer uid="888205">
			<para>(V16.0) Answer uid 888205</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888205" />
		  </answer>
		  
		<answer logic-note="STOP" uid="888206">
			<para>(V16.0) Answer uid 888206</para>
		</answer>
    </question>
	
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_22_2_143" uid="888102">
    <para>(V16.0) Question uid 888102</para>
	
		<answer uid="888207">
			<para>Answer uid 888207</para>
		</answer>
		
		<answer uid="888208">
			<para>(V16.0) Answer uid 888208</para>        
			<problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888209">
			<para>(V16.0) Answer uid 888209</para>
			<problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888210">
			<para>Answer uid 888210</para>
			 <problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888211">
			<para>(V16.0) Answer uid 888211</para>
			<problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888212">
			<para>(V16.0) Answer uid 888212</para>
		</answer>
		
    </question>

    
	<problem id="p_iccg_034_29_4_144" uid="888301">
      <para>(V16.0) Problem uid 888301</para>
      <note type="evidence">Moderate alcohol consumption (2 drinks/day in men or 1 drink/day in women) has been associated with positive cardiovascular outcomes.<citation db_id="79156" linkend="cit_iccg_042_001" cl="cl_c_48" display_value="13" /> A review of alcohol use disorders provides evidence-based screening, treatment, and referral guidance.<citation db_id="51269" linkend="cit_iccg_042_002" cl="cl_c_49" display_value="14" /> The Alcohol Use Disorders Identification Test (AUDIT) questionnaire''s 3-item subset of questions about alcohol consumption (AUDIT-C) is a brief screening test for problem drinking that has been validated in primary care office settings.<citation db_id="79141" linkend="cit_iccg_042_003" cl="cl_c_50" display_value="15" /></note>
 
		<goal uid="888401">
        <para>(V16.0) Goal uid 888401</para>
		
			<intervention type="assist" uid="888501">
			  <para>(V16.0) Intervention 888401</para>
			</intervention>
			
			<intervention type="send" uid="888502">
			  <para>(V16.0) Intervention uid 888401
				<ulink url="pted_641.pdf" product="ccg" hsim="pted_641" sp_url="/sp_pted/pted_641_esp.pdf">Websites - Substance abuse</ulink>
			  </para>
			</intervention>
		</goal>
	  
		<goal uid="888402">
        <para>(V16.0) Goal uid 888402</para>
		
			<intervention type="educate" uid="888503">
			  <para>(V16.0) Intervention uid 888503</para>
			</intervention>
			
			<intervention type="educate" uid="888504">
			  <para>(V16.0) Intervention 888504</para>
			</intervention>
			<intervention type="educate" uid="888505">
			  <para>(V16.0) Intervention 888505</para>
			</intervention>
			<intervention type="educate" uid="888506">
			  <para>(V16.0) Intervention uid 888506</para>
			</intervention>
      </goal>
	  
	  <goal uid="888403">
        <para>(V16.0) Goal uid 888403</para>
		
			<intervention type="educate" uid="888507">
			  <para>(V16.0) Intervention uid 888507</para>
			</intervention>
			
			<intervention type="educate" uid="888508">
			  <para>(V16.0) Intervention uid 888508</para>
			</intervention>        
      </goal>
	  
	  	  <goal uid="888404">
        <para>(V16.0) Goal uid 888404</para>
		
			<intervention type="educate" uid="888509">
			  <para>(V16.0) Intervention uid 888509</para>
			</intervention>
			
			<intervention type="educate" uid="888510">
			  <para>(V16.0) Intervention uid 888510</para>
			</intervention> 
			
			<intervention type="assist" uid="888511">
			  <para>(V16.0) Intervention 888511</para>
			</intervention>
			
			<intervention type="send" uid="888512">
			  <para>(V16.0) Intervention uid 888512
				<ulink url="pted_641.pdf" product="ccg" hsim="pted_641" sp_url="/sp_pted/pted_641_esp.pdf">Websites - Substance abuse</ulink>
			  </para>
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
          ( 'iccg_888'
           ,'CCG'
           ,16.0
           ,'GA'
           ,'/TestSection/TestSection2'
           ,'  <guideline-sect3 astoriaid="00000018WGA51F3GYZ" contentsource="1" contenttype="Section" displayorder="1" id="Alcohol Abuse_iccg_105" idsection="340796" logic_type="5" role="TestSection2">
    <heading>TestSection2</heading>
     <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_5_1_143" uid="888201">
      <para>(V16.0) Question uid 888201</para>

		<answer logic-note="STOP" uid="888201">
			<para>(V16.0) 888201</para>
		</answer>      
	 
		<answer uid="888202">
			<para>(V16.0) Answer uid 888202</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888202" />
		</answer>

		<answer uid="888203">
			<para>(V16.0) Answer uid 888203</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888203" />
		</answer>

		<answer uid="888204">
			<para>(V16.0) Answer uid 888204</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888204" />
		</answer>

		 <answer uid="888205">
			<para>(V16.0) Answer uid 888205</para>
			<questionref linkend="q_iccg_034_22_2_143" uid="888205" />
		  </answer>
		  
		<answer logic-note="STOP" uid="888206">
			<para>(V16.0) Answer uid 888206</para>
		</answer>
    </question>
	
    <question piping="true" type="single" target="patient" forwarding="false" id="q_iccg_034_22_2_143" uid="888102">
    <para>(V16.0) Question uid 888102</para>
	
		<answer uid="888207">
			<para>Answer uid 888207</para>
		</answer>
		
		<answer uid="888208">
			<para>(V16.0) Answer uid 888208</para>        
			<problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888209">
			<para>(V16.0) Answer uid 888209</para>
			<problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888210">
			<para>Answer uid 888210</para>
			 <problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888211">
			<para>(V16.0) Answer uid 888211</para>
			<problemref linkend="p_iccg_034_29_4_144" uid="21" />
		</answer>
		
		<answer uid="888212">
			<para>(V16.0) Answer uid 888212</para>
		</answer>
		
    </question>

    
	<problem id="p_iccg_034_29_4_144" uid="888301">
      <para>(V16.0) Problem uid 888301</para>
      <note type="evidence">Moderate alcohol consumption (2 drinks/day in men or 1 drink/day in women) has been associated with positive cardiovascular outcomes.<citation db_id="79156" linkend="cit_iccg_042_001" cl="cl_c_48" display_value="13" /> A review of alcohol use disorders provides evidence-based screening, treatment, and referral guidance.<citation db_id="51269" linkend="cit_iccg_042_002" cl="cl_c_49" display_value="14" /> The Alcohol Use Disorders Identification Test (AUDIT) questionnaire''s 3-item subset of questions about alcohol consumption (AUDIT-C) is a brief screening test for problem drinking that has been validated in primary care office settings.<citation db_id="79141" linkend="cit_iccg_042_003" cl="cl_c_50" display_value="15" /></note>
 
		<goal uid="888401">
        <para>(V16.0) Goal uid 888401</para>
		
			<intervention type="assist" uid="888501">
			  <para>(V16.0) Intervention 888401</para>
			</intervention>
			
			<intervention type="send" uid="888502">
			  <para>(V16.0) Intervention uid 888401
				<ulink url="pted_641.pdf" product="ccg" hsim="pted_641" sp_url="/sp_pted/pted_641_esp.pdf">Websites - Substance abuse</ulink>
			  </para>
			</intervention>
		</goal>
	  
		<goal uid="888402">
        <para>(V16.0) Goal uid 888402</para>
		
			<intervention type="educate" uid="888503">
			  <para>(V16.0) Intervention uid 888503</para>
			</intervention>
			
			<intervention type="educate" uid="888504">
			  <para>(V16.0) Intervention 888504</para>
			</intervention>
			<intervention type="educate" uid="888505">
			  <para>(V16.0) Intervention 888505</para>
			</intervention>
			<intervention type="educate" uid="888506">
			  <para>(V16.0) Intervention uid 888506</para>
			</intervention>
      </goal>
	  
	  <goal uid="888403">
        <para>(V16.0) Goal uid 888403</para>
		
			<intervention type="educate" uid="888507">
			  <para>(V16.0) Intervention uid 888507</para>
			</intervention>
			
			<intervention type="educate" uid="888508">
			  <para>(V16.0) Intervention uid 888508</para>
			</intervention>        
      </goal>
	  
	  	  <goal uid="888404">
        <para>(V16.0) Goal uid 888404</para>
		
			<intervention type="educate" uid="888509">
			  <para>(V16.0) Intervention uid 888509</para>
			</intervention>
			
			<intervention type="educate" uid="888510">
			  <para>(V16.0) Intervention uid 888510</para>
			</intervention> 
			
			<intervention type="assist" uid="888511">
			  <para>(V16.0) Intervention 888511</para>
			</intervention>
			
			<intervention type="send" uid="888512">
			  <para>(V16.0) Intervention uid 888512
				<ulink url="pted_641.pdf" product="ccg" hsim="pted_641" sp_url="/sp_pted/pted_641_esp.pdf">Websites - Substance abuse</ulink>
			  </para>
			</intervention>			
      </goal>
    </problem>
  </guideline-sect3>'
           ,NULL
           ,NULL
           ,2
           ,16
           ,0)