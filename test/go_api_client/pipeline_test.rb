require 'test_helper'

module GoApiClient
  class PipelineTest < Test::Unit::TestCase

    LINK = 'http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml'
    def setup
      stub_request(:get, LINK).to_return(:body => file_contents('pipelines_1.xml'))
    end

    test 'should fetch the pipeline xml and populate itself' do
      pipeline = GoApiClient::Client.new.api(:pipeline).pipeline({:pipeline_uri => LINK})

      assert_equal '1', pipeline.label
      assert_equal 99, pipeline.counter
      assert_equal 'defaultPipeline', pipeline.name
      assert_equal 'http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml', pipeline.self_uri
      assert_equal 'urn:x-go.studios.thoughtworks.com:job-id:defaultPipeline:1', pipeline.id
      assert_equal Time.parse('2012-02-23 11:46:15 UTC'), pipeline.schedule_time
    end

    test 'should only parse materials with type=GitMaterial' do
      doc = Nokogiri::XML.parse %q{<?xml version="1.0" encoding="UTF-8"?>

        <pipeline name="GreenInstallers" counter="286" label="286">
          <link rel="self" href="https://go.example.com/go/api/pipelines/GreenInstallers/122316.xml"/>
          <id><![CDATA[urn:x-go.studios.thoughtworks.com:job-id:GreenInstallers:286]]></id>
          <link rel="insertedBefore" href="https://go.example.com/go/api/pipelines/GreenInstallers/122309.xml"/>
          <link rel="insertedAfter" href="https://go.example.com/go/api/pipelines/GreenInstallers/122286.xml"/>
          <scheduleTime>2013-02-08T20:34:12-08:00</scheduleTime>
          <materials>
            <material materialUri="https://go.example.com/go/api/materials/5185.xml" type="GitMaterial" url="git@github.com:test-repo.git" branch="master">
              <modifications>
                <changeset changesetUri="https://go.example.com/go/api/materials/5185/changeset/bc9cc9401b816d753f267227934e535affcb4028.xml">
                  <user><![CDATA[wdephill <wdephill@thoughtworks.com>]]></user>
                  <checkinTime>2013-02-08T16:19:18-08:00</checkinTime>
                  <revision><![CDATA[bc9cc9401b816d753f267227934e535affcb4028]]></revision>
                  <message><![CDATA[ #14163 - [WYSIWYG] Column layout. Use plugin onchange to ensure that there is an empty p at the end of the doc so that you can get out of the column.]]></message>
                  <file name="public/javascripts/ckeditor/config.js" action="modified"/>
                  <file name="public/javascripts/ckeditor/plugins/onchange/docs/install.html" action="added"/>
                  <file name="public/javascripts/ckeditor/plugins/onchange/docs/styles.css" action="added"/>
                  <file name="public/javascripts/ckeditor/plugins/onchange/plugin.js" action="added"/>
                </changeset>
              </modifications>
            </material>
            <material materialUri="https://go.example.com/go/api/materials/30536.xml" type="DependencyMaterial" pipelineName="IE8-PostgreSQL9" stageName="Acceptances">
              <modifications>
                <changeset changesetUri="https://go.example.com/go/api/stages/264242.xml">
                  <checkinTime>2013-02-08T20:33:45-08:00</checkinTime>
                  <revision>IE8-PostgreSQL9/942/Acceptances/1</revision>
                </changeset>
              </modifications>
            </material>
          </materials>
          <stages>
            <stage href="https://go.example.com/go/api/stages/264258.xml"/>
            <stage href="https://go.example.com/go/api/stages/264271.xml"/>
          </stages>
          <approvedBy><![CDATA[changes]]></approvedBy>
        </pipeline>
      }

      pipeline = GoApiClient::Parsers::Pipeline.parse(doc.root)
      assert_equal 2, pipeline.parsed_materials.count
      material = pipeline.parsed_materials.first
      assert_equal 1, material.parsed_changesets.count
      changeset = material.parsed_changesets.first

      assert_equal 'bc9cc9401b816d753f267227934e535affcb4028',        changeset.revision
      assert_equal GoApiClient::Domain::User.new('wdephill', 'wdephill@thoughtworks.com'), changeset.parsed_user
      assert_equal Time.parse('2013-02-09 00:19:18 UTC'),             changeset.checkin_time
    end

    test 'should schedule a build specified' do
      stub_request(:post, 'http://go-server.2.project:8153/go/api/pipelines/defaultPipeline/schedule')
      GoApiClient::Client.new({:host => 'go-server.2.project'}).api(:pipeline).schedule({:pipeline_name => 'defaultPipeline'})

      assert_requested(:post, 'http://go-server.2.project:8153/go/api/pipelines/defaultPipeline/schedule', :body => '')
    end
  end
end
