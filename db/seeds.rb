# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
class AddSeedObjects < ActiveRecord::Migration[5.1]
  File.readlines('db/types_of_repairs.txt').each do |line|
    ControlledVocabulary.create(
      vocabulary: 'repair_type',
      key: line.strip,
      active: true
    )
  end

  File.readlines('db/contract_conservators.txt').each do |line|
    ControlledVocabulary.create(
      vocabulary: 'contract_conservator',
      key: line.strip,
      active: true
    )
  end

  File.readlines('db/departments.txt').each do |line|
    ControlledVocabulary.create(
      vocabulary: 'department',
      key: line.strip,
      active: true
    )
  end

  File.readlines('db/housing.txt').each do |line|
    ControlledVocabulary.create(
      vocabulary: 'housing',
      key: line.strip,
      active: true
    )
  end

  StaffCode.create(
    [
      {
        code: 'C',
        points: 20
      },
      {
        code: 'T',
        points: 10
      },
      {
        code: 'S',
        points: 4
      },
      {
        code: 'V',
        points: 0
      },
      {
        code: 'A',
        points: 15
      }
    ]
  )

  if ENV['SEEDABLE'] == 'true'
    puts '"SEEDABLE" is true. Performing user data and conservation record seeding.' unless Rails.env.test?

    User.create(
      [{
         display_name: 'John Green',
         role: 'read_only',
         username: 'johngreen'
       },
       {
         display_name: 'JK Rowling',
         role: 'standard',
         username: 'jkrowling'
       },
       {
         display_name: 'Chuck Greenman',
         role: 'admin',
         username: 'chuck'
       },
       {
         display_name: 'Rondi Dibbini',
         role: 'admin',
         username: 'dibbinrm'
       },
       {
         display_name: 'Janell Huyck',
         role: 'admin',
         username: 'huyckjl'
       },
       {
         display_name: 'Glen Horton',
         role: 'admin',
         username: 'hortongn'
       },
       {
         display_name: 'Lisa Haitz',
         role: 'admin',
         username: 'haitzlm'
       },
       {
         display_name: 'Thomas Scherz',
         role: 'admin',
         username: 'scherztc'
       }]
    )

    ConservationRecord.create(
      [
        {
          date_received_in_preservation_services: Time.now,
          department: ControlledVocabulary.where(vocabulary: 'department').sample(1).first.id,
          title: 'Farewell to Arms',
          author: 'Ernest Hemingway',
          imprint: 'Scribner',
          call_number: 'PS3515.E37 F3 1995',
          item_record_number: 'i58811072',
          digitization: false
        },
        {
          date_received_in_preservation_services: Time.now - 1.days,
          department: ControlledVocabulary.where(vocabulary: 'department').sample(1).first.id,
          title: 'Ulysses',
          author: 'James Joyce',
          imprint: 'Picador',
          call_number: 'PR6019.O9 U4 1997',
          item_record_number: 'i58811073',
          digitization: true
        },
        {
          date_received_in_preservation_services: Time.now - 2.days,
          department: ControlledVocabulary.where(vocabulary: 'department').sample(1).first.id,
          title: 'The Great Gatsby',
          author: 'F. Scott Fitzgerald',
          imprint: 'Scribner',
          call_number: 'PS3511.I9 G7 2004',
          item_record_number: 'i58811074',
          digitization: true
        }
      ]
    )
  else
    puts 'Skipping user data and conservation record seeding.' unless Rails.env.test?
  end
end
