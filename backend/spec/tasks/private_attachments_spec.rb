require 'rails_helper'
require 'rake'
require 'fileutils'

RSpec.describe 'attachments:privatize' do
  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?('attachments:privatize')
    Rake::Task['attachments:privatize'].reenable
  end

  let!(:attachment) { create(:incident_attachment) }
  let(:destination) { Pathname.new(attachment.file.path) }
  let(:source) { Rails.root.join('public', attachment.file.store_dir, attachment.file_identifier) }

  after do
    FileUtils.rm_f(source)
    FileUtils.rm_f(destination)
  end

  it 'moves legacy files out of public and can run again without changing the PDF' do
    contents = destination.binread
    FileUtils.mkdir_p(source.dirname)
    FileUtils.mv(destination, source)

    Rake::Task['attachments:privatize'].invoke

    expect(source).not_to exist
    expect(destination.binread).to eq(contents)
    Rake::Task['attachments:privatize'].reenable
    Rake::Task['attachments:privatize'].invoke
    expect(destination.binread).to eq(contents)
  end

  it 'stops on a conflicting destination without overwriting either file' do
    FileUtils.mkdir_p(source.dirname)
    source.write('legacy file')
    contents = destination.binread

    expect { Rake::Task['attachments:privatize'].invoke }.to raise_error(/Destination already exists/)
    expect(destination.binread).to eq(contents)
    expect(source.read).to eq('legacy file')
  end
end
